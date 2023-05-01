# [FP and OOP in JavaScript](https://github.com/cristi-salcescu/discover-functional-javascript)

Functional Programming

- keeps data and functions separate
- avoids state change and mutable data
- treats functions as first-class citizens
- focuses on what rather than how (making code more readable)

## Chapter 1: A brief overview of JavaScript

Objects are dynamic collections of key-value pairs.

Arrays are indexed collections of values.

Primitives, objects and functions are all values.

### Functions

Functions are independent units and can be invoked in different ways:

- Function declaration: `function doSomething() {}`
- Function expression: `const doSomething = function() {};`
- Arrow function: `const doSomething = () => {};`

### Dynamic typing

Values have types, variables do not. Thus, types may change at runtime.

## Chapter 2: New features in ES6+

`let` and `const` declare and initialise variables.

Modules encapsulate functionality and expose only a small part.

The spread operator, rest parameter, property shorthand, destructuring assignments, default parameters, template string literals, etc. make things easier to express.

### Arrow functions

Arrow functions can implicitly return a value.

The value of `this` is not bound.

There is no arguments object with arrow functions.

### Proper tail-calls

### Promises

## Chapter 3: First-class functions

### First-class functions

First-class enable using functions as values, thus treating functions like any other type of values.

### Higher-order functions

A higher-order function is a function that takes another function as argument, returns a function or does both.

### `filter()`

### `map()`

### `reduce()`

### `sort()`

## Chapter 4: Closures

### Lexical scope

A closure is an inner function that has access to the outer (lexical) scope, even after the outer scope container has executed.

### Surviving parent execution

Variables used in closures live as long as the closure itself; before being garbage collected.

### Closures in loop

Closures store references to values.

### Generators

Generators are closures.

### Functions with private state

Closures create encapsulation.

This is called the Revealing Modules pattern in JS. The same behaviour can be achieved using ES6 modules or classes.

## Chapter 5: Function decorators

A function decorator is a higher-order function that takes one function as an argument, and returns another function, where the returned function is a variation of the argument function.

### `once()`

### `after()`

### `throttle()`

### `debounce()`

### `memoize()`

Unlike caching, memoization only works with deterministic functions.

### `unary()`

### `binary()`

### Preserve function context

In order to preserve the original function context:

- The decorator should return a function using the `function` keyword, not the arrow syntax.
- The original function should be called with `fn.apply(this, args)` or `fn.call(this, ...args)`.

## Chapter 6: Pure functions

A pure function is a function that, given the same imput, always returns the same output, and has no side effects.

Pure functions make the code easier to read, understand, test, debug, compose.

### Free variables

Free variables are variables that are neither local to the function nor a parameter.

Pure functions may access free variables - if they are `const`ants!

### Immutability

It is a good practice to return immutable values.

### Deterministic functions

A pure function is a deterministic function. Hence, for example, `next` is not a pure function: it has no side effects, but is not deterministic.

### Referential transparency

A function has referential transparency if it can be replaced with its output value, and the application behaviour does not change.

A function that has referential transparency is a pure function.

### The problem

The problem with pure functions is that we can't write the whole application using pure functions.

Pure functions wouldn't be able to communicate with the external environment.

Aim for purity, and separate the pure and impure parts of the code base.

## Chapter 7: Immutability

### Primitives

Primitive values are immutable, e.g. any modification to a string will create a new string.

Objects are not.

### Constants

`const` declares a variable that cannot be reassigned. It becomes a constant only when the assigned value is immutable.

### Freezing objects

`Object.freeze()` only does a shallow freeze.

```javascript
function deepFreeze(object) {
  Object.keys(object).forEach(name => {
    const value = object[name];

    if (typeof value === "object") {
      deepFreeze(value);
    }
  });

  return Object.freeze(object);
}
```

### `Immutable.js`

`Immutable.js` provides immutable data structures like `List` and `Map`.

### Transfer objects

Data transfer objects (DTOs) are plain objects containing only data that move around the application from one function to another.

To avoid any unexpected changes, they should be immutable.

### Change detection

## Chapter 8: Partial application and currying

### Partial application

Partial application is the process of fixing a number of arguments to a function by producing another function with fewer arguments. The returned function is a partially applied function.

### Currying

Currying transforms a function that takes multiple arguments into a sequence of functions where each takes one argument only.

### Arity

Partial applicaiton and currying decrease the arity of a function. Currying transforms a n-ary function into n unary functions.

## Chapter 9: Function composition

Function composition is a means of passing the output of a function as the input for another function.

### `compose()`

```javascript
f(g(x)) === compose(f, g)(x);
```

### `pipe()`

Pipelines make data transformations more expressive.

## Chapter 10: Intention-revealing names

## Chapter 11: Making code easier to read

### Refactoring with `filter()`, `map()` and `reduce()`

Chaining is a technique where multiple methods are applied to an object one after another.

### Point-free style

```javascript
const filteredTodos = todos.filter(todo => isPriorityTodo(todo)).map(todo => toTodoView(todo));
```

Point-free style is a technique that improves readability by eliminating unnecessary arguments:

```javascript
const filteredTodos = todos.filter(isPriorityTodo).map(toTodoView);
```

### Decomposition

Our aim is to create small pure functions with intention-revealing names, and then compose them back together. Thus, there will be two kinds of functions:

- functions doing one task
- functions coordinating a lot of tasks, using a point-free style

## Chapter 12: Asynchronous programming

### Blocking vs not blocking

Synchronous code is blocking. Asynchronous code is not, the functions returns immediately with a `Promise`.

### The Event Loop

The event loop uses a queue, so callbacks are processed in the order they are are added.

### Web Workers

Web workers offer a way to run long-running tasks. These tasks run in parallel and don't affect the main thread.

When a long-running task has finished, the result is communicated back to the main thread.

There is no shared memory between the main thread and web workers.

## Chapter 13: Objects with prototypes

The prototypal inheritance has the benefit of memory conservation: the prototype is created once and used by all the instances.

## Chapter 14: Objects with closures

Closures can be created as functions with private state. More than that, we can create many closures sharing the same private state. This way, we can build objects as collections of closures. Closures encapsulate state.

### Memory

Classes are better at memory conservation, as they are implemented over the prototype system. All methods will be created once in the prototype object and shared by all instances.

The memory cost of using closures is noticeable when creating thousands of the same object.

### Composition over inheritance

Factory functions promote composition over inheritance.

## Chapter 15: Method decorators

With decorators, we can separate pure from impure code:

- `getter()` takes a pure function and creates a function that returns the current state transformed with the pure function
- `setter()` takes a pure function and creates a function that modifies the state using the pure function

## Chapter 16: Waiting for the new programming paradigm

Split objects inside an application in two:

- **Data objects** that expose data and have no behaviour. Data objects are immutable.
- **Behaviour objects** that expose behaviour and hide data.

Or, from a different perspective:

- Data objects are immutable collections of primitives or other plain objects.
- Behaviour objects are immutable collections of closures sharing the same private state.

Functional programming is better at data transformations and making code easier to understand.

Objects are better at encapsulating side effects and managing state.
