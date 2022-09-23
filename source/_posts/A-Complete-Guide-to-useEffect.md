---
title: A Complete Guide to useEffect
tags:
  - React
  - React Hooks
  - useEffect
categories:
  - 前端
  - React
  - React Hooks
description: useEffect 完整指南 — Dan Abramov
related_posts: true
abbrlink: '6387'
---


> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 <https://overreacted.io/a-complete-guide-to-useeffect/>

You wrote a few components with [Hooks](https://reactjs.org/docs/hooks-intro.html). Maybe even a small app. You’re mostly satisfied. You’re comfortable with the API and picked up a few tricks along the way. You even made some [custom Hooks](https://reactjs.org/docs/hooks-custom.html) to extract repetitive logic (300 lines gone!) and showed it off to your colleagues. “Great job”, they said.

But sometimes when you `useEffect`, the pieces don’t quite fit together. You have a nagging feeling that you’re missing something. It seems similar to class lifecycles… but is it really? You find yourself asking questions like:

* 🤔 How do I replicate `componentDidMount` with `useEffect`?
* 🤔 How do I correctly fetch data inside `useEffect`? What is `[]`?
* 🤔 Do I need to specify functions as effect dependencies or not?
* 🤔 Why do I sometimes get an infinite refetching loop?
* 🤔 Why do I sometimes get an old state or prop value inside my effect?

When I just started using Hooks, I was confused by all of those questions too. Even when writing the initial docs, I didn’t have a firm grasp on some of the subtleties. I’ve since had a few “aha” moments that I want to share with you. **This deep dive will make the answers to these questions look obvious to you.**

To _see_ the answers, we need to take a step back. The goal of this article isn’t to give you a list of bullet point recipes. It’s to help you truly “grok” `useEffect`. There won’t be much to learn. In fact, we’ll spend most of our time _un_learning.

**It’s only after I stopped looking at the `useEffect` Hook through the prism of the familiar class lifecycle methods that everything came together for me.**

> “Unlearn what you have learned.” — Yoda

 [![](https://overreacted.io/static/6203a1f1f2c771816a5ba0969baccd12/5ed8a/yoda.jpg)](https://overreacted.io/static/6203a1f1f2c771816a5ba0969baccd12/5ed8a/yoda.jpg)

**This article assumes that you’re somewhat familiar with [`useEffect`](https://reactjs.org/docs/hooks-effect.html) API.**

**It’s also _really_ long. It’s like a mini-book. That’s just my preferred format. But I wrote a TLDR just below if you’re in a rush or don’t really care.**

**If you’re not comfortable with deep dives, you might want to wait until these explanations appear elsewhere. Just like when React came out in 2013, it will take some time for people to recognize a different mental model and teach it.**

[](#tldr)TLDR
-------------

Here’s a quick TLDR if you don’t want to read the whole thing. If some parts don’t make sense, you can scroll down until you find something related.

Feel free to skip it if you plan to read the whole post. I’ll link to it at the end.

**🤔 Question: How do I replicate `componentDidMount` with `useEffect`?**

While you can `useEffect(fn, [])`, it’s not an exact equivalent. Unlike `componentDidMount`, it will _capture_ props and state. So even inside the callbacks, you’ll see the initial props and state. If you want to see “latest” something, you can write it to a ref. But there’s usually a simpler way to structure the code so that you don’t have to. Keep in mind that the mental model for effects is different from `componentDidMount` and other lifecycles, and trying to find their exact equivalents may confuse you more than help. To get productive, you need to “think in effects”, and their mental model is closer to implementing synchronization than to responding to lifecycle events.

**🤔 Question: How do I correctly fetch data inside `useEffect`? What is `[]`?**

[This article](https://www.robinwieruch.de/react-hooks-fetch-data/) is a good primer on data fetching with `useEffect`. Make sure to read it to the end! It’s not as long as this one. `[]` means the effect doesn’t use any value that participates in React data flow, and is for that reason safe to apply once. It is also a common source of bugs when the value actually _is_ used. You’ll need to learn a few strategies (primarily `useReducer` and `useCallback`) that can _remove the need_ for a dependency instead of incorrectly omitting it.

**🤔 Question: Do I need to specify functions as effect dependencies or not?**

The recommendation is to hoist functions that don’t need props or state _outside_ of your component, and pull the ones that are used only by an effect _inside_ of that effect. If after that your effect still ends up using functions in the render scope (including function from props), wrap them into `useCallback` where they’re defined, and repeat the process. Why does it matter? Functions can “see” values from props and state — so they participate in the data flow. There’s a [more detailed answer](https://reactjs.org/docs/hooks-faq.html#is-it-safe-to-omit-functions-from-the-list-of-dependencies) in our FAQ.

**🤔 Question: Why do I sometimes get an infinite refetching loop?**

This can happen if you’re doing data fetching in an effect without the second dependencies argument. Without it, effects run after every render — and setting the state will trigger the effects again. An infinite loop may also happen if you specify a value that _always_ changes in the dependency array. You can tell which one by removing them one by one. However, removing a dependency you use (or blindly specifying `[]`) is usually the wrong fix. Instead, fix the problem at its source. For example, functions can cause this problem, and putting them inside effects, hoisting them out, or wrapping them with `useCallback` helps. To avoid recreating objects, `useMemo` can serve a similar purpose.

**🤔 Why do I sometimes get an old state or prop value inside my effect?**

Effects always “see” props and state from the render they were defined in. That [helps prevent bugs](https://overreacted.io/how-are-function-components-different-from-classes/) but in some cases can be annoying. For those cases, you can explicitly maintain some value in a mutable ref (the linked article explains it at the end). If you think you’re seeing some props or state from an old render but don’t expect it, you probably missed some dependencies. Try using the [lint rule](https://github.com/facebook/react/issues/14920) to train yourself to see them. A few days, and it’ll be like a second nature to you. See also [this answer](https://reactjs.org/docs/hooks-faq.html#why-am-i-seeing-stale-props-or-state-inside-my-function) in our FAQ.

I hope this TLDR was helpful! Otherwise, let’s go.

[](#each-render-has-its-own-props-and-state)Each Render Has Its Own Props and State
-----------------------------------------------------------------------------------

Before we can talk about effects, we need to talk about rendering.

Here’s a counter. Look at the highlighted line closely:

```
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}

```

What does it mean? Does `count` somehow “watch” changes to our state and update automatically? That might be a useful first intuition when you learn React but it’s _not_ an [accurate mental model](https://overreacted.io/react-as-a-ui-runtime/).

**In this example, `count` is just a number.** It’s not a magic “data binding”, a “watcher”, a “proxy”, or anything else. It’s a good old number like this one:

```
const count = 42;

<p>You clicked {count} times</p>


```

The first time our component renders, the `count` variable we get from `useState()` is `0`. When we call `setCount(1)`, React calls our component again. This time, `count` will be `1`. And so on:

```
function Counter() {
  const count = 0;   
  <p>You clicked {count} times</p>
  
}


function Counter() {
  const count = 1;   
  <p>You clicked {count} times</p>
  
}


function Counter() {
  const count = 2;   
  <p>You clicked {count} times</p>
  
}

```

**Whenever we update the state, React calls our component. Each render result “sees” its own `counter` state value which is a _constant_ inside our function.**

So this line doesn’t do any special data binding:

```
<p>You clicked {count} times</p>

```

**It only embeds a number value into the render output.** That number is provided by React. When we `setCount`, React calls our component again with a different `count` value. Then React updates the DOM to match our latest render output.

The key takeaway is that the `count` constant inside any particular render doesn’t change over time. It’s our component that’s called again — and each render “sees” its own `count` value that’s isolated between renders.

_(For an in-depth overview of this process, check out my post [React as a UI Runtime](https://overreacted.io/react-as-a-ui-runtime/).)_

[](#each-render-has-its-own-event-handlers)Each Render Has Its Own Event Handlers
---------------------------------------------------------------------------------

So far so good. What about event handlers?

Look at this example. It shows an alert with the `count` after three seconds:

```
function Counter() {
  const [count, setCount] = useState(0);

  function handleAlertClick() {    setTimeout(() => {      alert('You clicked on: ' + count);    }, 3000);  }
  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
      <button onClick={handleAlertClick}>        Show alert      </button>    </div>
  );
}

```

Let’s say I do this sequence of steps:

* **Increment** the counter to 3
* **Press** “Show alert”
* **Increment** it to 5 before the timeout fires

![](https://overreacted.io/counter-46c55d5f1f749462b7a173f1e748e41e.gif)

What do you expect the alert to show? Will it show 5 — which is the counter state at the time of the alert? Or will it show 3 — the state when I clicked?

_spoilers ahead_

Go ahead and [try it yourself!](https://codesandbox.io/s/w2wxl3yo0l)

If the behavior doesn’t quite make sense to you, imagine a more practical example: a chat app with the current recipient ID in the state, and a Send button. [This article](https://overreacted.io/how-are-function-components-different-from-classes/) explores the reasons in depth but the correct answer is 3.

The alert will “capture” the state at the time I clicked the button.

_(There are ways to implement the other behavior too but I’ll be focusing on the default case for now. When building a mental model, it’s important that we distinguish the “path of least resistance” from the opt-in escape hatches.)_

But how does it work?

We’ve discussed that the `count` value is constant for every particular call to our function. It’s worth emphasizing this — **our function gets called many times (once per each render), but every one of those times the `count` value inside of it is constant and set to a particular value (state for that render).**

This is not specific to React — regular functions work in a similar way:

```
function sayHi(person) {
  const name = person.name;  setTimeout(() => {
    alert('Hello, ' + name);
  }, 3000);
}

let someone = {name: 'Dan'};
sayHi(someone);

someone = {name: 'Yuzhi'};
sayHi(someone);

someone = {name: 'Dominic'};
sayHi(someone);

```

In [this example](https://codesandbox.io/s/mm6ww11lk8), the outer `someone` variable is reassigned several times. (Just like somewhere in React, the _current_ component state can change.) **However, inside `sayHi`, there is a local `name` constant that is associated with a `person` from a particular call.** That constant is local, so it’s isolated between the calls! As a result, when the timeouts fire, each alert “remembers” its own `name`.

This explains how our event handler captures the `count` at the time of the click. If we apply the same substitution principle, each render “sees” its own `count`:

```
function Counter() {
  const count = 0;   
  function handleAlertClick() {
    setTimeout(() => {
      alert('You clicked on: ' + count);
    }, 3000);
  }
  
}


function Counter() {
  const count = 1;   
  function handleAlertClick() {
    setTimeout(() => {
      alert('You clicked on: ' + count);
    }, 3000);
  }
  
}


function Counter() {
  const count = 2;   
  function handleAlertClick() {
    setTimeout(() => {
      alert('You clicked on: ' + count);
    }, 3000);
  }
  
}

```

So effectively, each render returns its own “version” of `handleAlertClick`. Each of those versions “remembers” its own `count`:

```
function Counter() {
  
  function handleAlertClick() {
    setTimeout(() => {
      alert('You clicked on: ' + 0);    }, 3000);
  }
  
  <button onClick={handleAlertClick} />   
}


function Counter() {
  
  function handleAlertClick() {
    setTimeout(() => {
      alert('You clicked on: ' + 1);    }, 3000);
  }
  
  <button onClick={handleAlertClick} />   
}


function Counter() {
  
  function handleAlertClick() {
    setTimeout(() => {
      alert('You clicked on: ' + 2);    }, 3000);
  }
  
  <button onClick={handleAlertClick} />   
}

```

This is why [in this demo](https://codesandbox.io/s/w2wxl3yo0l) event handlers “belong” to a particular render, and when you click, it keeps using the `counter` state _from_ that render.

**Inside any particular render, props and state forever stay the same.** But if props and state are isolated between renders, so are any values using them (including the event handlers). They also “belong” to a particular render. So even async functions inside an event handler will “see” the same `count` value.

_Side note: I inlined concrete `count` values right into `handleAlertClick` functions above. This mental substitution is safe because `count` can’t possibly change within a particular render. It’s declared as a `const` and is a number. It would be safe to think the same way about other values like objects too, but only if we agree to avoid mutating state. Calling `setSomething(newObj)` with a newly created object instead of mutating it is fine because state belonging to previous renders is intact._

[](#each-render-has-its-own-effects)Each Render Has Its Own Effects
-------------------------------------------------------------------

This was supposed to be a post about effects but we still haven’t talked about effects yet! We’ll rectify this now. Turns out, effects aren’t really any different.

Let’s go back to an example from [the docs](https://reactjs.org/docs/hooks-effect.html):

```
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {    document.title = `You clicked ${count} times`;  });
  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}

```

**Here’s a question for you: how does the effect read the latest `count` state?**

Maybe, there’s some kind of “data binding” or “watching” that makes `count` update live inside the effect function? Maybe `count` is a mutable variable that React sets inside our component so that our effect always sees the latest value?

Nope.

We already know that `count` is constant within a particular component render. Event handlers “see” the `count` state from the render that they “belong” to because `count` is a variable in their scope. The same is true for effects!

**It’s not the `count` variable that somehow changes inside an “unchanging” effect. It’s the _effect function itself_ that’s different on every render.**

Each version “sees” the `count` value from the render that it “belongs” to:

```
function Counter() {
  
  useEffect(
        () => {      document.title = `You clicked ${0} times`;    }  );
  
}


function Counter() {
  
  useEffect(
        () => {      document.title = `You clicked ${1} times`;    }  );
  
}


function Counter() {
  
  useEffect(
        () => {      document.title = `You clicked ${2} times`;    }  );
  
}

```

React remembers the effect function you provided, and runs it after flushing changes to the DOM and letting the browser paint the screen.

So even if we speak of a single conceptual _effect_ here (updating the document title), it is represented by a _different function_ on every render — and each effect function “sees” props and state from the particular render it “belongs” to.

**Conceptually, you can imagine effects are a _part of the render result_.**

Strictly saying, they’re not (in order to [allow Hook composition](https://overreacted.io/why-do-hooks-rely-on-call-order/) without clumsy syntax or runtime overhead). But in the mental model we’re building up, effect functions _belong_ to a particular render in the same way that event handlers do.

To make sure we have a solid understanding, let’s recap our first render:

* **React:** Give me the UI when the state is `0`.
* **Your component:**

  * Here’s the render result: `<p>You clicked 0 times</p>`.
  * Also remember to run this effect after you’re done: `() => { document.title = 'You clicked 0 times' }`.
* **React:** Sure. Updating the UI. Hey browser, I’m adding some stuff to the DOM.
* **Browser:** Cool, I painted it to the screen.
* **React:** OK, now I’m going to run the effect you gave me.

  * Running `() => { document.title = 'You clicked 0 times' }`.

Now let’s recap what happens after we click:

* **Your component:** Hey React, set my state to `1`.
* **React:** Give me the UI for when the state is `1`.
* **Your component:**

  * Here’s the render result: `<p>You clicked 1 times</p>`.
  * Also remember to run this effect after you’re done: `() => { document.title = 'You clicked 1 times' }`.
* **React:** Sure. Updating the UI. Hey browser, I’ve changed the DOM.
* **Browser:** Cool, I painted your changes to the screen.
* **React:** OK, now I’ll run the effect that belongs to the render I just did.

  * Running `() => { document.title = 'You clicked 1 times' }`.

[](#each-render-has-its-own-everything)Each Render Has Its Own… Everything
--------------------------------------------------------------------------

**We know now that effects run after every render, are conceptually a part of the component output, and “see” the props and state from that particular render.**

Let’s try a thought experiment. Consider this code:

```
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {    setTimeout(() => {      console.log(`You clicked ${count} times`);    }, 3000);  });
  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}

```

If I click several times with a small delay, what is the log going to look like?

_spoilers ahead_

You might think this is a gotcha and the end result is unintuitive. It’s not! We’re going to see a sequence of logs — each one belonging to a particular render and thus with its own `count` value. You can [try it yourself](https://codesandbox.io/s/lyx20m1ol):

![](https://overreacted.io/timeout_counter-a5727d333c270e05942f508707265378.gif)

You may think: “Of course that’s how it works! How else could it work?”

Well, that’s not how `this.state` works in classes. It’s easy to make the mistake of thinking that this [class implementation](https://codesandbox.io/s/kkymzwjqz3) is equivalent:

```
  componentDidUpdate() {
    setTimeout(() => {
      console.log(`You clicked ${this.state.count} times`);
    }, 3000);
  }

```

However, `this.state.count` always points at the _latest_ count rather than the one belonging to a particular render. So you’ll see `5` logged each time instead:

![](https://overreacted.io/timeout_counter_class-264b329edc111a1973003bdf2bcacd65.gif)

I think it’s ironic that Hooks rely so much on JavaScript closures, and yet it’s the class implementation that suffers from [the canonical wrong-value-in-a-timeout confusion](https://wsvincent.com/javascript-closure-settimeout-for-loop/) that’s often associated with closures. This is because the actual source of the confusion in this example is the mutation (React mutates `this.state` in classes to point to the latest state) and not closures themselves.

**Closures are great when the values you close over never change. That makes them easy to think about because you’re essentially referring to constants.** And as we discussed, props and state never change within a particular render. By the way, we can fix the class version… by [using a closure](https://codesandbox.io/s/w7vjo07055).

[](#swimming-against-the-tide)Swimming Against the Tide
-------------------------------------------------------

At this point it’s important that we call it out explicitly: **every** function inside the component render (including event handlers, effects, timeouts or API calls inside them) captures the props and state of the render call that defined it.

So these two examples are equivalent:

```
function Example(props) {
  useEffect(() => {
    setTimeout(() => {
      console.log(props.counter);    }, 1000);
  });
  
}

```

```
function Example(props) {
  const counter = props.counter;  useEffect(() => {
    setTimeout(() => {
      console.log(counter);    }, 1000);
  });
  
}

```

**It doesn’t matter whether you read from props or state “early” inside of your component.** They’re not going to change! Inside the scope of a single render, props and state stay the same. (Destructuring props makes this more obvious.)

Of course, sometimes you _want_ to read the latest rather than captured value inside some callback defined in an effect. The easiest way to do it is by using refs, as described in the last section of [this article](https://overreacted.io/how-are-function-components-different-from-classes/).

Be aware that when you want to read the _future_ props or state from a function in a _past_ render, you’re swimming against the tide. It’s not _wrong_ (and in some cases necessary) but it might look less “clean” to break out of the paradigm. This is an intentional consequence because it helps highlight which code is fragile and depends on timing. In classes, it’s less obvious when this happens.

Here’s a [version of our counter example](https://codesandbox.io/s/rm7z22qnlp) that replicates the class behavior:

```
function Example() {
  const [count, setCount] = useState(0);
  const latestCount = useRef(count);
  useEffect(() => {
        latestCount.current = count;    setTimeout(() => {
            console.log(`You clicked ${latestCount.current} times`);    }, 3000);
  });
  

```

![](https://overreacted.io/timeout_counter_refs-78f7948263dd13b023498b23cb99f4fc.gif)

It might seem quirky to mutate something in React. However, this is exactly how React itself reassigns `this.state` in classes. Unlike with captured props and state, you don’t have any guarantees that reading `latestCount.current` would give you the same value in any particular callback. By definition, you can mutate it any time. This is why it’s not a default, and you have to opt into that.

[](#so-what-about-cleanup)So What About Cleanup?
------------------------------------------------

As [the docs explain](https://reactjs.org/docs/hooks-effect.html#effects-with-cleanup), some effects might have a cleanup phase. Essentially, its purpose is to “undo” an effect for cases like subscriptions.

Consider this code:

```
  useEffect(() => {
    ChatAPI.subscribeToFriendStatus(props.id, handleStatusChange);
    return () => {
      ChatAPI.unsubscribeFromFriendStatus(props.id, handleStatusChange);
    };
  });

```

Say `props` is `{id: 10}` on the first render, and `{id: 20}` on the second render. You _might_ think that something like this happens:

* React cleans up the effect for `{id: 10}`.
* React renders UI for `{id: 20}`.
* React runs the effect for `{id: 20}`.

(This is not quite the case.)

With this mental model, you might think the cleanup “sees” the old props because it runs before we re-render, and then the new effect “sees” the new props because it runs after the re-render. That’s the mental model lifted directly from the class lifecycles, and **it’s not accurate here**. Let’s see why.

React only runs the effects after [letting the browser paint](https://medium.com/@dan_abramov/this-benchmark-is-indeed-flawed-c3d6b5b6f97f). This makes your app faster as most effects don’t need to block screen updates. Effect cleanup is also delayed. **The previous effect is cleaned up _after_ the re-render with new props:**

* **React renders UI for `{id: 20}`.**
* The browser paints. We see the UI for `{id: 20}` on the screen.
* **React cleans up the effect for `{id: 10}`.**
* React runs the effect for `{id: 20}`.

You might be wondering: but how can the cleanup of the previous effect still “see” the old `{id: 10}` props if it runs _after_ the props change to `{id: 20}`?

We’ve been here before… 🤔

![](https://overreacted.io/deja_vu-5fe238cf03a21dfa32af624124fcdcff.gif)

Quoting the previous section:

> Every function inside the component render (including event handlers, effects, timeouts or API calls inside them) captures the props and state of the render call that defined it.

Now the answer is clear! The effect cleanup doesn’t read the “latest” props, whatever that means. It reads props that belong to the render it’s defined in:

```
function Example() {
  
  useEffect(
    
    () => {
      ChatAPI.subscribeToFriendStatus(10, handleStatusChange);
            return () => {        ChatAPI.unsubscribeFromFriendStatus(10, handleStatusChange);      };    }
  );
  
}


function Example() {
  
  useEffect(
    
    () => {
      ChatAPI.subscribeToFriendStatus(20, handleStatusChange);
      
      return () => {
        ChatAPI.unsubscribeFromFriendStatus(20, handleStatusChange);
      };
    }
  );
  
}

```

Kingdoms will rise and turn into ashes, the Sun will shed its outer layers to be a white dwarf, and the last civilization will end. But nothing will make the props “seen” by the first render effect’s cleanup anything other than `{id: 10}`.

That’s what allows React to deal with effects right after painting — and make your apps faster by default. The old props are still there if our code needs them.

[](#synchronization-not-lifecycle)Synchronization, Not Lifecycle
----------------------------------------------------------------

One of my favorite things about React is that it unifies describing the initial render result and the updates. This [reduces the entropy](https://overreacted.io/the-bug-o-notation/) of your program.

Say my component looks like this:

```
function Greeting({ name }) {
  return (
    <h1 class>
      Hello, {name}
    </h1>
  );
}

```

It doesn’t matter if I render `<Greeting />` and later `<Greeting />`, or if I just render `<Greeting />`. In the end, we will see “Hello, Yuzhi” in both cases.

People say: “It’s all about the journey, not the destination”. With React, it’s the opposite. **It’s all about the destination, not the journey.** That’s the difference between `$.addClass` and `$.removeClass` calls in jQuery code (our “journey”) and specifying what the CSS class _should be_ in React code (our “destination”).

**React synchronizes the DOM according to our current props and state.** There is no distinction between a “mount” or an “update” when rendering.

You should think of effects in a similar way. **`useEffect` lets you _synchronize_ things outside of the React tree according to our props and state.**

```
function Greeting({ name }) {
  useEffect(() => {    document.title = 'Hello, ' + name;  });  return (
    <h1 class>
      Hello, {name}
    </h1>
  );
}

```

This is subtly different from the familiar _mount/update/unmount_ mental model. It is important really to internalize this. **If you’re trying to write an effect that behaves differently depending on whether the component renders for the first time or not, you’re swimming against the tide!** We’re failing at synchronizing if our result depends on the “journey” rather than the “destination”.

It shouldn’t matter whether we rendered with props A, B, and C, or if we rendered with C immediately. While there may be some temporary differences (e.g. while we’re fetching data), eventually the end result should be the same.

Still, of course running all effects on _every_ render might not be efficient. (And in some cases, it would lead to infinite loops.)

So how can we fix this?

[](#teaching-react-to-diff-your-effects)Teaching React to Diff Your Effects
---------------------------------------------------------------------------

We’ve already learned that lesson with the DOM itself. Instead of touching it on every re-render, React only updates the parts of the DOM that actually change.

When you’re updating

```
<h1 class>
  Hello, Dan
</h1>

```

to

```
<h1 class>
  Hello, Yuzhi
</h1>

```

React sees two objects:

```
const oldProps = {className: 'Greeting', children: 'Hello, Dan'};
const newProps = {className: 'Greeting', children: 'Hello, Yuzhi'};

```

It goes over each of their props and determine that `children` have changed and need a DOM update, but `className` did not. So it can just do:

```
domNode.innerText = 'Hello, Yuzhi';


```

**Could we do something like this with effects too? It would be nice to avoid re-running them when applying the effect is unnecessary.**

For example, maybe our component re-renders because of a state change:

```
function Greeting({ name }) {
  const [counter, setCounter] = useState(0);

  useEffect(() => {
    document.title = 'Hello, ' + name;
  });

  return (
    <h1 class>
      Hello, {name}
      <button onClick={() => setCounter(count + 1)}>        Increment      </button>    </h1>
  );
}

```

But our effect doesn’t use the `counter` state. **Our effect synchronizes the `document.title` with the `name` prop, but the `name` prop is the same.** Re-assigning `document.title` on every counter change seems non-ideal.

OK, so can React just… diff effects?

```
let oldEffect = () => { document.title = 'Hello, Dan'; };
let newEffect = () => { document.title = 'Hello, Dan'; };


```

Not really. React can’t guess what the function does without calling it. (The source doesn’t really contain specific values, it just closes over the `name` prop.)

This is why if you want to avoid re-running effects unnecessarily, you can provide a dependency array (also known as “deps”) argument to `useEffect`:

```
  useEffect(() => {
    document.title = 'Hello, ' + name;
  }, [name]); 

```

**It’s like if we told React: “Hey, I know you can’t see _inside_ this function, but I promise it only uses `name` and nothing else from the render scope.”**

If each of these values is the same between the current and the previous time this effect ran, there’s nothing to synchronize so React can skip the effect:

```
const oldEffect = () => { document.title = 'Hello, Dan'; };
const oldDeps = ['Dan'];

const newEffect = () => { document.title = 'Hello, Dan'; };
const newDeps = ['Dan'];




```

If even one of the values in the dependency array is different between renders, we know running the effect can’t be skipped. Synchronize all the things!

[](#dont-lie-to-react-about-dependencies)Don’t Lie to React About Dependencies
------------------------------------------------------------------------------

Lying to React about dependencies has bad consequences. Intuitively, this makes sense, but I’ve seen pretty much everyone who tries `useEffect` with a mental model from classes try to cheat the rules. (And I did that too at first!)

```
function SearchResults() {
  async function fetchData() {
    
  }

  useEffect(() => {
    fetchData();
  }, []); 

  
}

```

_(The [Hooks FAQ](https://reactjs.org/docs/hooks-faq.html#is-it-safe-to-omit-functions-from-the-list-of-dependencies) explains what to do instead. We’ll come back to this example [below](#moving-functions-inside-effects).)_

“But I only want to run it on mount!”, you’ll say. For now, remember: if you specify deps, **_all_ values from inside your component that are used by the effect _must_ be there**. Including props, state, functions — anything in your component.

Sometimes when you do that, it causes a problem. For example, maybe you see an infinite refetching loop, or a socket is recreated too often. **The solution to that problem is _not_ to remove a dependency.** We’ll look at the solutions soon.

But before we jump to solutions, let’s understand the problem better.

[](#what-happens-when-dependencies-lie)What Happens When Dependencies Lie
-------------------------------------------------------------------------

If deps contain every value used by the effect, React knows when to re-run it:

```
  useEffect(() => {
    document.title = 'Hello, ' + name;
  }, [name]);

```

![](https://overreacted.io/deps-compare-correct-fae247cd068eedbd4b62ba50592d2b3d.gif)

_(Dependencies are different, so we re-run the effect.)_

But if we specified `[]` for this effect, the new effect function wouldn’t run:

```
  useEffect(() => {
    document.title = 'Hello, ' + name;
  }, []); 

```

![](https://overreacted.io/deps-compare-wrong-25f75db3f9f57ffe1426912093577445.gif)

_(Dependencies are equal, so we skip the effect.)_

In this case the problem might seem obvious. But the intuition can fool you in other cases where a class solution “jumps out” from your memory.

For example, let’s say we’re writing a counter that increments every second. With a class, our intuition is: “Set up the interval once and destroy it once”. Here’s an [example](https://codesandbox.io/s/n5mjzjy9kl) of how we can do it. When we mentally translate this code to `useEffect`, we instinctively add `[]` to the deps. “I want it to run once”, right?

```
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const id = setInterval(() => {
      setCount(count + 1);
    }, 1000);
    return () => clearInterval(id);
  }, []);
  return <h1>{count}</h1>;
}

```

However, this example [only _increments_ once](https://codesandbox.io/s/91n5z8jo7r). _Oops._

If your mental model is “dependencies let me specify when I want to re-trigger the effect”, this example might give you an existential crisis. You _want_ to trigger it once because it’s an interval — so why is it causing issues?

However, this makes sense if you know that dependencies are our hint to React about _everything_ that the effect uses from the render scope. It uses `count` but we lied that it doesn’t with `[]`. It’s only a matter of time before this bites us!

In the first render, `count` is `0`. Therefore, `setCount(count + 1)` in the first render’s effect means `setCount(0 + 1)`. **Since we never re-run the effect because of `[]` deps, it will keep calling `setCount(0 + 1)` every second:**

```
function Counter() {
  
  useEffect(
    
    () => {
      const id = setInterval(() => {
        setCount(0 + 1);       }, 1000);
      return () => clearInterval(id);
    },
    []   );
  
}


function Counter() {
  
  useEffect(
            () => {
      const id = setInterval(() => {
        setCount(1 + 1);
      }, 1000);
      return () => clearInterval(id);
    },
    []
  );
  
}

```

We lied to React by saying our effect doesn’t depend on a value from inside our component, when in fact it does!

Our effect uses `count` — a value inside the component (but outside the effect):

```
  const count = 
  useEffect(() => {
    const id = setInterval(() => {
      setCount(count + 1);    }, 1000);
    return () => clearInterval(id);
  }, []);

```

Therefore, specifying `[]` as a dependency will create a bug. React will compare the dependencies, and skip updating this effect:

![](https://overreacted.io/interval-wrong-29e53bd0c9b7d2ac70d3cd924886b030.gif)

_(Dependencies are equal, so we skip the effect.)_

Issues like this are difficult to think about. Therefore, I encourage you to adopt it as a hard rule to always be honest about the effect dependencies, and specify them all. (We provide a [lint rule](https://github.com/facebook/react/issues/14920) if you want to enforce this on your team.)

[](#two-ways-to-be-honest-about-dependencies)Two Ways to Be Honest About Dependencies
-------------------------------------------------------------------------------------

There are two strategies to be honest about dependencies. You should generally start with the first one, and then apply the second one if needed.

**The first strategy is to fix the dependency array to include _all_ the values inside the component that are used inside the effect.** Let’s include `count` as a dep:

```
useEffect(() => {
  const id = setInterval(() => {
    setCount(count + 1);  }, 1000);
  return () => clearInterval(id);
}, [count]);

```

This makes the dependency array correct. It may not be _ideal_ but that’s the first issue we needed to fix. Now a change to `count` will re-run the effect, with each next interval referencing `count` from its render in `setCount(count + 1)`:

```
function Counter() {
  
  useEffect(
    
    () => {
      const id = setInterval(() => {
        setCount(0 + 1);       }, 1000);
      return () => clearInterval(id);
    },
    [0]   );
  
}


function Counter() {
  
  useEffect(
    
    () => {
      const id = setInterval(() => {
        setCount(1 + 1);       }, 1000);
      return () => clearInterval(id);
    },
    [1]   );
  
}

```

That would [fix the problem](https://codesandbox.io/s/0x0mnlyq8l) but our interval would be cleared and set again whenever the `count` changes. That may be undesirable:

![](https://overreacted.io/interval-rightish-5734271ddfa94d2d65ac6160515e0069.gif)

_(Dependencies are different, so we re-run the effect.)_

**The second strategy is to change our effect code so that it wouldn’t _need_ a value that changes more often than we want.** We don’t want to lie about the dependencies — we just want to change our effect to have _fewer_ of them.

Let’s look at a few common techniques for removing dependencies.

[](#making-effects-self-sufficient)Making Effects Self-Sufficient
-----------------------------------------------------------------

We want to get rid of the `count` dependency in our effect.

```
  useEffect(() => {
    const id = setInterval(() => {
      setCount(count + 1);    }, 1000);
    return () => clearInterval(id);
  }, [count]);

```

To do this, we need to ask ourselves: **what are we using `count` for?** It seems like we only use it for the `setCount` call. In that case, we don’t actually need `count` in the scope at all. When we want to update state based on the previous state, we can use the [functional updater form](https://reactjs.org/docs/hooks-reference.html#functional-updates) of `setState`:

```
  useEffect(() => {
    const id = setInterval(() => {
      setCount(c => c + 1);    }, 1000);
    return () => clearInterval(id);
  }, []);

```

I like to think of these cases as “false dependencies”. Yes, `count` was a necessary dependency because we wrote `setCount(count + 1)` inside the effect. However, we only truly needed `count` to transform it into `count + 1` and “send it back” to React. But React _already knows_ the current `count`. **All we needed to tell React is to increment the state — whatever it is right now.**

That’s exactly what `setCount(c => c + 1)` does. You can think of it as “sending an instruction” to React about how the state should change. This “updater form” also helps in other cases, like when you [batch multiple updates](https://overreacted.io/react-as-a-ui-runtime/#batching).

**Note that we actually _did the work_ to remove the dependency. We didn’t cheat. Our effect doesn’t read the `counter` value from the render scope anymore:**

![](https://overreacted.io/interval-right-f128ad20c28317ed27a3cb68197fc906.gif)

_(Dependencies are equal, so we skip the effect.)_

You can try it [here](https://codesandbox.io/s/q3181xz1pj).

Even though this effect only runs once, the interval callback that belongs to the first render is perfectly capable of sending the `c => c + 1` update instruction every time the interval fires. It doesn’t need to know the current `counter` state anymore. React already knows it.

[](#functional-updates-and-google-docs)Functional Updates and Google Docs
-------------------------------------------------------------------------

Remember how we talked about synchronization being the mental model for effects? An interesting aspect of synchronization is that you often want to keep the “messages” between the systems untangled from their state. For example, editing a document in Google Docs doesn’t actually send the _whole_ page to the server. That would be very inefficient. Instead, it sends a representation of what the user tried to do.

While our use case is different, a similar philosophy applies to effects. **It helps to send only the minimal necessary information from inside the effects into a component.** The updater form like `setCount(c => c + 1)` conveys strictly less information than `setCount(count + 1)` because it isn’t “tainted” by the current count. It only expresses the action (“incrementing”). Thinking in React involves [finding the minimal state](https://reactjs.org/docs/thinking-in-react.html#step-3-identify-the-minimal-but-complete-representation-of-ui-state). This is the same principle, but for updates.

Encoding the _intent_ (rather than the result) is similar to how Google Docs [solves](https://medium.com/@srijancse/how-real-time-collaborative-editing-work-operational-transformation-ac4902d75682) collaborative editing. While this is stretching the analogy, functional updates serve a similar role in React. They ensure updates from multiple sources (event handlers, effect subscriptions, etc) can be correctly applied in a batch and in a predictable way.

**However, even `setCount(c => c + 1)` isn’t that great.** It looks a bit weird and it’s very limited in what it can do. For example, if we had two state variables whose values depend on each other, or if we needed to calculate the next state based on a prop, it wouldn’t help us. Luckily, `setCount(c => c + 1)` has a more powerful sister pattern. Its name is `useReducer`.

[](#decoupling-updates-from-actions)Decoupling Updates from Actions
-------------------------------------------------------------------

Let’s modify the previous example to have two state variables: `count` and `step`. Our interval will increment the count by the value of the `step` input:

```
function Counter() {
  const [count, setCount] = useState(0);
  const [step, setStep] = useState(1);

  useEffect(() => {
    const id = setInterval(() => {
      setCount(c => c + step);    }, 1000);
    return () => clearInterval(id);
  }, [step]);
  return (
    <>
      <h1>{count}</h1>
      <input value={step} onChange={e => setStep(Number(e.target.value))} />
    </>
  );
}

```

(Here’s a [demo](https://codesandbox.io/s/zxn70rnkx).)

Note that **we’re not cheating**. Since I started using `step` inside the effect, I added it to the dependencies. And that’s why the code runs correctly.

The current behavior in this example is that changing the `step` restarts the interval — because it’s one of the dependencies. And in many cases, that is exactly what you want! There’s nothing wrong with tearing down an effect and setting it up anew, and we shouldn’t avoid that unless we have a good reason.

However, let’s say we want the interval clock to not reset on changes to the `step`. How do we remove the `step` dependency from our effect?

**When setting a state variable depends on the current value of another state variable, you might want to try replacing them both with `useReducer`.**

When you find yourself writing `setSomething(something => ...)`, it’s a good time to consider using a reducer instead. A reducer lets you **decouple expressing the “actions” that happened in your component from how the state updates in response to them**.

Let’s trade the `step` dependency for a `dispatch` dependency in our effect:

```
const [state, dispatch] = useReducer(reducer, initialState);const { count, step } = state;

useEffect(() => {
  const id = setInterval(() => {
    dispatch({ type: 'tick' });   }, 1000);
  return () => clearInterval(id);
}, [dispatch]);

```

(See the [demo](https://codesandbox.io/s/xzr480k0np).)

You might ask me: “How is this any better?” The answer is that **React guarantees the `dispatch` function to be constant throughout the component lifetime. So the example above doesn’t ever need to resubscribe the interval.**

We solved our problem!

_(You may omit `dispatch`, `setState`, and `useRef` container values from the deps because React guarantees them to be static. But it also doesn’t hurt to specify them.)_

Instead of reading the state _inside_ an effect, it dispatches an _action_ that encodes the information about _what happened_. This allows our effect to stay decoupled from the `step` state. Our effect doesn’t care _how_ we update the state, it just tells us about _what happened_. And the reducer centralizes the update logic:

```
const initialState = {
  count: 0,
  step: 1,
};

function reducer(state, action) {
  const { count, step } = state;
  if (action.type === 'tick') {    return { count: count + step, step };  } else if (action.type === 'step') {
    return { count, step: action.step };
  } else {
    throw new Error();
  }
}

```

(Here’s a [demo](https://codesandbox.io/s/xzr480k0np) if you missed it earlier).

[](#why-usereducer-is-the-cheat-mode-of-hooks)Why useReducer Is the Cheat Mode of Hooks
---------------------------------------------------------------------------------------

We’ve seen how to remove dependencies when an effect needs to set state based on previous state, or on another state variable. **But what if we need _props_ to calculate the next state?** For example, maybe our API is `<Counter step={1} />`. Surely, in this case we can’t avoid specifying `props.step` as a dependency?

In fact, we can! We can put _the reducer itself_ inside our component to read props:

```
function Counter({ step }) {  const [count, dispatch] = useReducer(reducer, 0);

  function reducer(state, action) {
    if (action.type === 'tick') {
      return state + step;    } else {
      throw new Error();
    }
  }

  useEffect(() => {
    const id = setInterval(() => {
      dispatch({ type: 'tick' });
    }, 1000);
    return () => clearInterval(id);
  }, [dispatch]);

  return <h1>{count}</h1>;
}

```

This pattern disables a few optimizations so try not to use it everywhere, but you can totally access props from a reducer if you need to. (Here’s a [demo](https://codesandbox.io/s/7ypm405o8q).)

**Even in that case, `dispatch` identity is still guaranteed to be stable between re-renders.** So you may omit it from the effect deps if you want. It’s not going to cause the effect to re-run.

You may be wondering: how can this possibly work? How can the reducer “know” props when called from inside an effect that belongs to another render? The answer is that when you `dispatch`, React just remembers the action — but it will _call_ your reducer during the next render. At that point the fresh props will be in scope, and you won’t be inside an effect.

**This is why I like to think of `useReducer` as the “cheat mode” of Hooks. It lets me decouple the update logic from describing what happened. This, in turn, helps me remove unnecessary dependencies from my effects and avoid re-running them more often than necessary.**

[](#moving-functions-inside-effects)Moving Functions Inside Effects
-------------------------------------------------------------------

A common mistake is to think functions shouldn’t be dependencies. For example, this seems like it could work:

```
function SearchResults() {
  const [data, setData] = useState({ hits: [] });

  async function fetchData() {
    const result = await axios(
      'https://hn.algolia.com/api/v1/search?query=react',
    );
    setData(result.data);
  }

  useEffect(() => {
    fetchData();
  }, []); 
  

```

_([This example](https://codesandbox.io/s/8j4ykjyv0) is adapted from a great article by Robin Wieruch — [check it out](https://www.robinwieruch.de/react-hooks-fetch-data/)!)_

And to be clear, this code _does_ work. **But the problem with simply omitting local functions is that it gets pretty hard to tell whether we’re handling all cases as the component grows!**

Imagine our code was split like this and each function was five times larger:

```
function SearchResults() {
  
  function getFetchUrl() {
    return 'https://hn.algolia.com/api/v1/search?query=react';
  }

  
  async function fetchData() {
    const result = await axios(getFetchUrl());
    setData(result.data);
  }

  useEffect(() => {
    fetchData();
  }, []);

  
}

```

Now let’s say we later use some state or prop in one of these functions:

```
function SearchResults() {
  const [query, setQuery] = useState('react');

  
  function getFetchUrl() {
    return 'https://hn.algolia.com/api/v1/search?query=' + query;  }

  
  async function fetchData() {
    const result = await axios(getFetchUrl());
    setData(result.data);
  }

  useEffect(() => {
    fetchData();
  }, []);

  
}

```

If we forget to update the deps of any effects that call these functions (possibly, through other functions!), our effects will fail to synchronize changes from our props and state. This doesn’t sound great.

Luckily, there is an easy solution to this problem. **If you only use some functions _inside_ an effect, move them directly _into_ that effect:**

```
function SearchResults() {
  
  useEffect(() => {
        function getFetchUrl() {      return 'https://hn.algolia.com/api/v1/search?query=react';    }    async function fetchData() {      const result = await axios(getFetchUrl());      setData(result.data);    }
    fetchData();
  }, []); 
  
}

```

([Here’s a demo](https://codesandbox.io/s/04kp3jwwql).)

So what is the benefit? We no longer have to think about the “transitive dependencies”. Our dependencies array isn’t lying anymore: **we truly _aren’t_ using anything from the outer scope of the component in our effect**.

If we later edit `getFetchUrl` to use the `query` state, we’re much more likely to notice that we’re editing it _inside_ an effect — and therefore, we need to add `query` to the effect dependencies:

```
function SearchResults() {
  const [query, setQuery] = useState('react');

  useEffect(() => {
    function getFetchUrl() {
      return 'https://hn.algolia.com/api/v1/search?query=' + query;    }

    async function fetchData() {
      const result = await axios(getFetchUrl());
      setData(result.data);
    }

    fetchData();
  }, [query]); 
  
}

```

(Here’s a [demo](https://codesandbox.io/s/pwm32zx7z7).)

By adding this dependency, we’re not just “appeasing React”. It _makes sense_ to refetch the data when the query changes. **The design of `useEffect` forces you to notice the change in our data flow and choose how our effects should synchronize it — instead of ignoring it until our product users hit a bug.**

Thanks to the `exhaustive-deps` lint rule from the `eslint-plugin-react-hooks` plugin, you can [analyze the effects as you type in your editor](https://github.com/facebook/react/issues/14920) and receive suggestions about which dependencies are missing. In other words, a machine can tell you which data flow changes aren’t handled correctly by a component.

![](https://overreacted.io/exhaustive-deps-04a90dcbacb01105d634964880ebed19.gif)

Pretty sweet.

[](#but-i-cant-put-this-function-inside-an-effect)But I Can’t Put This Function Inside an Effect
------------------------------------------------------------------------------------------------

Sometimes you might not want to move a function _inside_ an effect. For example, several effects in the same component may call the same function, and you don’t want to copy and paste its logic. Or maybe it’s a prop.

Should you skip a function like this in the effect dependencies? I think not. Again, **effects shouldn’t lie about their dependencies.** There are usually better solutions. A common misconception is that “a function would never change”. But as we learned throughout this article, this couldn’t be further from truth. Indeed, a function defined inside a component changes on every render!

**That by itself presents a problem.** Say two effects call `getFetchUrl`:

```
function SearchResults() {
  function getFetchUrl(query) {
    return 'https://hn.algolia.com/api/v1/search?query=' + query;
  }

  useEffect(() => {
    const url = getFetchUrl('react');
    
  }, []); 

  useEffect(() => {
    const url = getFetchUrl('redux');
    
  }, []); 

  
}

```

In that case you might not want to move `getFetchUrl` inside either of the effects since you wouldn’t be able to share the logic.

On the other hand, if you’re “honest” about the effect dependencies, you may run into a problem. Since both our effects depend on `getFetchUrl` **(which is different on every render)**, our dependency arrays are useless:

```
function SearchResults() {
    function getFetchUrl(query) {    return 'https://hn.algolia.com/api/v1/search?query=' + query;  }
  useEffect(() => {
    const url = getFetchUrl('react');
    
  }, [getFetchUrl]); 

  useEffect(() => {
    const url = getFetchUrl('redux');
    
  }, [getFetchUrl]); 

  
}

```

A tempting solution to this is to just skip the `getFetchUrl` function in the deps list. However, I don’t think it’s a good solution. This makes it difficult to notice when we _are_ adding a change to the data flow that _needs_ to be handled by an effect. This leads to bugs like the “never updating interval” we saw earlier.

Instead, there are two other solutions that are simpler.

**First of all, if a function doesn’t use anything from the component scope, you can hoist it outside the component and then freely use it inside your effects:**

```
function getFetchUrl(query) {  return 'https://hn.algolia.com/api/v1/search?query=' + query;}
function SearchResults() {
  useEffect(() => {
    const url = getFetchUrl('react');
    
  }, []); 

  useEffect(() => {
    const url = getFetchUrl('redux');
    
  }, []); 

  
}

```

There’s no need to specify it in deps because it’s not in the render scope and can’t be affected by the data flow. It can’t accidentally depend on props or state.

Alternatively, you can wrap it into the [`useCallback` Hook](https://reactjs.org/docs/hooks-reference.html#usecallback):

```
function SearchResults() {
    const getFetchUrl = useCallback((query) => {    return 'https://hn.algolia.com/api/v1/search?query=' + query;  }, []);  
  useEffect(() => {
    const url = getFetchUrl('react');
    
  }, [getFetchUrl]); 

  useEffect(() => {
    const url = getFetchUrl('redux');
    
  }, [getFetchUrl]); 

  
}

```

`useCallback` is essentially like adding another layer of dependency checks. It’s solving the problem on the other end — **rather than avoid a function dependency, we make the function itself only change when necessary**.

Let’s see why this approach is useful. Previously, our example showed two search results (for `'react'` and `'redux'` search queries). But let’s say we want to add an input so that you can search for an arbitrary `query`. So instead of taking `query` as an argument, `getFetchUrl` will now read it from local state.

We’ll immediately see that it’s missing a `query` dependency:

```
function SearchResults() {
  const [query, setQuery] = useState('react');
  const getFetchUrl = useCallback(() => { 
    return 'https://hn.algolia.com/api/v1/search?query=' + query;
  }, []);   
}

```

If I fix my `useCallback` deps to include `query`, any effect with `getFetchUrl` in deps will re-run whenever the `query` changes:

```
function SearchResults() {
  const [query, setQuery] = useState('react');

    const getFetchUrl = useCallback(() => {    return 'https://hn.algolia.com/api/v1/search?query=' + query;  }, [query]);  
  useEffect(() => {
    const url = getFetchUrl();
    
  }, [getFetchUrl]); 

  
}

```

Thanks to `useCallback`, if `query` is the same, `getFetchUrl` also stays the same, and our effect doesn’t re-run. But if `query` changes, `getFetchUrl` will also change, and we will re-fetch the data. It’s a lot like when you change some cell in an Excel spreadsheet, and the other cells using it recalculate automatically.

This is just a consequence of embracing the data flow and the synchronization mindset. **The same solution works for function props passed from parents:**

```
function Parent() {
  const [query, setQuery] = useState('react');

    const fetchData = useCallback(() => {    const url = 'https://hn.algolia.com/api/v1/search?query=' + query;      }, [query]);  
  return <Child fetchData={fetchData} />
}

function Child({ fetchData }) {
  let [data, setData] = useState(null);

  useEffect(() => {
    fetchData().then(setData);
  }, [fetchData]); 

  
}

```

Since `fetchData` only changes inside `Parent` when its `query` state changes, our `Child` won’t refetch the data until it’s actually necessary for the app.

[](#are-functions-part-of-the-data-flow)Are Functions Part of the Data Flow?
----------------------------------------------------------------------------

Interestingly, this pattern is broken with classes in a way that really shows the difference between the effect and lifecycle paradigms. Consider this translation:

```
class Parent extends Component {
  state = {
    query: 'react'
  };
  fetchData = () => {    const url = 'https://hn.algolia.com/api/v1/search?query=' + this.state.query;      };  render() {
    return <Child fetchData={this.fetchData} />;
  }
}

class Child extends Component {
  state = {
    data: null
  };
  componentDidMount() {    this.props.fetchData();  }  render() {
    
  }
}

```

You might be thinking: “Come on Dan, we all know that `useEffect` is like `componentDidMount` and `componentDidUpdate` combined, you can’t keep beating that drum!” **Yet this doesn’t work even with `componentDidUpdate`:**

```
class Child extends Component {
  state = {
    data: null
  };
  componentDidMount() {
    this.props.fetchData();
  }
  componentDidUpdate(prevProps) {        if (this.props.fetchData !== prevProps.fetchData) {      this.props.fetchData();    }  }  render() {
    
  }
}

```

Of course, `fetchData` is a class method! (Or, rather, a class property — but that doesn’t change anything.) It’s not going to be different because of a state change. So `this.props.fetchData` will stay equal to `prevProps.fetchData` and we’ll never refetch. Let’s just remove this condition then?

```
  componentDidUpdate(prevProps) {
    this.props.fetchData();
  }

```

Oh wait, this fetches on _every_ re-render. (Adding an animation above in the tree is a fun way to discover it.) Maybe let’s bind it to a particular query?

```
  render() {
    return <Child fetchData={this.fetchData.bind(this, this.state.query)} />;
  }

```

But then `this.props.fetchData !== prevProps.fetchData` is _always_ `true`, even if the `query` didn’t change! So we’ll _always_ refetch.

The only real solution to this conundrum with classes is to bite the bullet and pass the `query` itself into the `Child` component. The `Child` doesn’t actually end up _using_ the `query`, but it can trigger a refetch when it changes:

```
class Parent extends Component {
  state = {
    query: 'react'
  };
  fetchData = () => {
    const url = 'https://hn.algolia.com/api/v1/search?query=' + this.state.query;
    
  };
  render() {
    return <Child fetchData={this.fetchData} query={this.state.query} />;  }
}

class Child extends Component {
  state = {
    data: null
  };
  componentDidMount() {
    this.props.fetchData();
  }
  componentDidUpdate(prevProps) {
    if (this.props.query !== prevProps.query) {      this.props.fetchData();    }  }
  render() {
    
  }
}

```

Over the years of working with classes with React, I’ve gotten so used to passing unnecessary props down and breaking encapsulation of parent components that I only realized a week ago why we had to do it.

**With classes, function props by themselves aren’t truly a part of the data flow.** Methods close over the mutable `this` variable so we can’t rely on their identity to mean anything. Therefore, even when we only want a function, we have to pass a bunch of other data around in order to be able to “diff” it. We can’t know whether `this.props.fetchData` passed from the parent depends on some state or not, and whether that state has just changed.

**With `useCallback`, functions can fully participate in the data flow.** We can say that if the function inputs changed, the function itself has changed, but if not, it stayed the same. Thanks to the granularity provided by `useCallback`, changes to props like `props.fetchData` can propagate down automatically.

Similarly, [`useMemo`](https://reactjs.org/docs/hooks-reference.html#usememo) lets us do the same for complex objects:

```
function ColorPicker() {
  
  
  const [color, setColor] = useState('pink');
  const style = useMemo(() => ({ color }), [color]);
  return <Child style={style} />;
}

```

**I want to emphasize that putting `useCallback` everywhere is pretty clunky.** It’s a nice escape hatch and it’s useful when a function is both passed down _and_ called from inside an effect in some children. Or if you’re trying to prevent breaking memoization of a child component. But Hooks lend themselves better to [avoiding passing callbacks down](https://reactjs.org/docs/hooks-faq.html#how-to-avoid-passing-callbacks-down) altogether.

In the above examples, I’d much prefer if `fetchData` was either inside my effect (which itself could be extracted to a custom Hook) or a top-level import. I want to keep the effects simple, and callbacks in them don’t help that. (“What if some `props.onComplete` callback changes while the request was in flight?”) You can [simulate the class behavior](#swimming-against-the-tide) but that doesn’t solve race conditions.

[](#speaking-of-race-conditions)Speaking of Race Conditions
-----------------------------------------------------------

A classic data fetching example with classes might look like this:

```
class Article extends Component {
  state = {
    article: null
  };
  componentDidMount() {
    this.fetchData(this.props.id);
  }
  async fetchData(id) {
    const article = await API.fetchArticle(id);
    this.setState({ article });
  }
  
}

```

As you probably know, this code is buggy. It doesn’t handle updates. So the second classic example you could find online is something like this:

```
class Article extends Component {
  state = {
    article: null
  };
  componentDidMount() {
    this.fetchData(this.props.id);
  }
  componentDidUpdate(prevProps) {    if (prevProps.id !== this.props.id) {      this.fetchData(this.props.id);    }  }  async fetchData(id) {
    const article = await API.fetchArticle(id);
    this.setState({ article });
  }
  
}

```

This is definitely better! But it’s still buggy. The reason it’s buggy is that the request may come out of order. So if I’m fetching `{id: 10}`, switch to `{id: 20}`, but the `{id: 20}` request comes first, the request that started earlier but finished later would incorrectly overwrite my state.

This is called a race condition, and it’s typical in code that mixes `async` / `await` (which assumes something waits for the result) with top-down data flow (props or state can change while we’re in the middle of an async function).

Effects don’t magically solve this problem, although they’ll warn you if you try to pass an `async` function to the effect directly. (We’ll need to improve that warning to better explain the problems you might run into.)

If the async approach you use supports cancellation, that’s great! You can cancel the async request right in your cleanup function.

Alternatively, the easiest stopgap approach is to track it with a boolean:

```
function Article({ id }) {
  const [article, setArticle] = useState(null);

  useEffect(() => {
    let didCancel = false;
    async function fetchData() {
      const article = await API.fetchArticle(id);
      if (!didCancel) {        setArticle(article);
      }
    }

    fetchData();

    return () => {      didCancel = true;    };  }, [id]);

  
}

```

[This article](https://www.robinwieruch.de/react-hooks-fetch-data/) goes into more detail about how you can handle errors and loading states, as well as extract that logic into a custom Hook. I recommend you to check it out if you’re interested to learn more about data fetching with Hooks.

[](#raising-the-bar)Raising the Bar
-----------------------------------

With the class lifecycle mindset, side effects behave differently from the render output. Rendering the UI is driven by props and state, and is guaranteed to be consistent with them, but side effects are not. This is a common source of bugs.

With the mindset of `useEffect`, things are synchronized by default. Side effects become a part of the React data flow. For every `useEffect` call, once you get it right, your component handles edge cases much better.

However, the upfront cost of getting it right is higher. This can be annoying. Writing synchronization code that handles edge cases well is inherently more difficult than firing one-off side effects that aren’t consistent with rendering.

This could be worrying if `useEffect` was meant to be _the_ tool you use most of the time. However, it’s a low-level building block. It’s an early time for Hooks so everybody uses low-level ones all the time, especially in tutorials. But in practice, it’s likely the community will start moving to higher-level Hooks as good APIs gain momentum.

I’m seeing different apps create their own Hooks like `useFetch` that encapsulates some of their app’s auth logic or `useTheme` which uses theme context. Once you have a toolbox of those, you don’t reach for `useEffect` _that_ often. But the resilience it brings benefits every Hook built on top of it.

So far, `useEffect` is most commonly used for data fetching. But data fetching isn’t exactly a synchronization problem. This is especially obvious because our deps are often `[]`. What are we even synchronizing?

In the longer term, [Suspense for Data Fetching](https://reactjs.org/blog/2018/11/27/react-16-roadmap.html#react-16x-mid-2019-the-one-with-suspense-for-data-fetching) will allow third-party libraries to have a first-class way to tell React to suspend rendering until something async (anything: code, data, images) is ready.

As Suspense gradually covers more data fetching use cases, I anticipate that `useEffect` will fade into background as a power user tool for cases when you actually want to synchronize props and state to some side effect. Unlike data fetching, it handles this case naturally because it was designed for it. But until then, custom Hooks like [shown here](https://www.robinwieruch.de/react-hooks-fetch-data/) are a good way to reuse data fetching logic.

[](#in-closing)In Closing
-------------------------

Now that you know pretty much everything I know about using effects, check out the [TLDR](#tldr) in the beginning. Does it make sense? Did I miss something? (I haven’t run out of paper yet!)

I’d love to hear from you on Twitter! Thanks for reading.
