# Clean Code

## Chapter 1: Clean Code

Beautiful code makes the language look like it was made for the problem: It is not the language that makes programmes appear simple. It is the programmer that makes the language appear simple!

### We are Authors

The `@author` field of a Javadoc tells us who we are.

### The Boy Scout Rule

## Chapter 2: Meaningful Names

### Use Intention-Revealing Names

### Avoid Disinformation

### Make Meaningful Distinctions

### Use Pronounceable Names

### Use Searchable Names

## Chapter 3: Functions

### Small

The indent level of a function should not be greater than one or two. The maximum length of a function should be around 20 lines.

### Don One Thing

Functions should do one thing. They should do it well. They should do it only.

Functions that do one thing cannot be reasonably divided into sections.

### One Level of Abstraction per Function

*The Stepdown Rule:* We want every function to be followed by those at the next level of abstraction so that we can read the programme, descending one level of abstraction at a time as we read down the list of functions.

### Switch Statements

`switch` statements by definition do more than one thing. Unfortunately, we can't always avoid `switch` statements, but we can make sure that each `switch` statement is buried in a low-level class and is never repeated.

`switch` statements are tolerable if they appear only once, are used to create polymorphic objects, and are hidden behind an inheritance relationship so the rest of the system can't see them; e.g. an abstract factory.

### Use Descriptive Names

### Function Arguments

The ideal number of arguments for a function is zero (niladic). Next comes one (monadic), followed closely by two (dyadic). Three arguments (triadic) should be avoided where possible. More than three (polyadic) requires very special justification—and then shouldn't be used anyway.

#### Flag Arguments

Flag arguments are ugly. Passing a boolean into a function is a truly terrible practice. A function should do one thing. Therefore, a function with a boolean argument does two things. It should be split in two.

#### Argument Objects

Create objects from cohesive groups of arguments. This reduces the number of arguments and makes the code more readable.

### Have No Side Effects

Side effects create strange temporal couplings.

### Command Query Separation

Functions should either do something or answer something, but not both. Either your function should change the state of an object, or it should return some information about that object.

### Prefer Exceptions to Returning Error Codes

If you use exceptions instead of returned error codes, then the error processing code can be separated from the happy path code and can be simplified.

Error Handling is one thing. Business Logic is another. Don't mix them.

Open-Closed Principle: When you use exceptions, then new exceptions are derivatives of the base exception class. This means that you can add new exceptions without changing existing code.

Functions are the verbs of the language, and classes are the nouns.

## Chapter 4: Comments

### Explain Yourself in Code

Comments do not make up for bad code. If the code is hard to understand, then rewrite it.

### Good Comments

- Legal Comments
- Warning of Consequences
- TODO Comments
- DocStrings

## Chapter 5: Formatting

## Chapter 6: Objects and Data Structures

### Data Abstraction

### Data/Object Anti-Symmetry

Objects hide their data behind abstractions and expose functions that operate on that data.

Data structures expose their data and have no meaningful functions.

They are virtual opposites.

Procedural code (code using data structures) makes it easy to add new functions without changing the existing data structures. OO code, on the other hand, makes it easy to add new classes without changing existing functions.

The complement is also true: Procedural code makes it hard to add new data structures because all the functions must change. OO code makes it hard to add new functions because all the classes must change.

In any complex system there are going to be times when we want to add new data types rather than new functions. For these cases, objects and OO are most appropriate. On the other hand, there will also be times when we'll want to add new functions as opposed to data types. In that case, procedural code and data structures will be more appropriate.

### The Law of Demeter

### Data Transfer Objects

The quintessential form of a data structure is a class with public variables and no functions. This is sometimes called a DTO. DTOs are very useful structures, especially when communicating with databases or parsing messages from sockets, and so on. They often become the first in a series of translation stages that convert raw data in a database into objects in the application.

*Active records* are special forms of DTOs. They are data structures with public (or bean-accessed) variables; but they typically have navigational methods like `save` and `find`. Typically, these Active Records are direct translations from database tables, or other data sources. They are however not objects, they are data structures. Separate objects must be created to represent the business logic of the application.

## Chapter 7: Error Handling

### Use Exceptions Rather Than Return Codes

### Write Your Try-Catch-Finally Statement First

### Use Unchecked Exceptions

The price of checked exceptions is an Open/Closed Principle violation. If you throw a checked exception from a method in your code and the `catch` is three levels above, you must declare that exception in the signature of each method between you and the `catch`.

### Provide Context with Exceptions

### Define Exception Classes in Terms of a Caller's Needs

### Define the Normal Flow

### Don't Return Null

### Don't Pass Null

## Chapter 8: Boundaries

We manage third-party boundaries by having very few places in the code that refer to them, ideally wrapped in an Adapter class.

## Chapter 9: Unit Tests

### The Three Laws of TDD

#### The First Law: You May Not Write Production Code Until You Have Written a Failing Unit Test

#### The Second Law: You May Not Write More of a Unit Test Than Is Sufficient to Fail, and Not Compiling Is Failing

#### The Third Law: You May Not Write More Production Code Than Is Sufficient to Pass the Currently Failing Test

### Keep Tests Clean

The problem is that tests must change as the production code evolves. The dirtier the tests, the harder they are to change.

### Clean Tests

### One Assert per Test

### F.I.R.S.T

*Fast:* Tests should be fast. If they are slow, then you'll be less likely to run them.

*Independent:* Tests should not depend on each other running in a particular order to pass, or on any state that is shared between them.

*Repeatable:* Tests should be repeatable in any environment. This means that they should not depend on any external system like a database, a file system, or a network connection.

*Self-Validating:* Tests should have boolean output: either pass or fail. They should not output anything else like logging or print to a screen.

*Timely:* Tests should be written in a timely fashion. The sooner you write the test, the sooner you'll find the defect.

## Chapter 10: Classes

Functions are the verbs, classes the nouns of our language.

### Class Organization

#### Encapcsulation

There is seldom a good reason to have a public variable.

We like to put the private utilities called by a public function right after the public function itself. This follows the stepdown rule and helps the programme read like a newspaper article.

### Classes Should be Small

#### The Single Responsibility Principle

A class or module should have one, and only one, reason to change.

Each small class encapsulates a single responsibility, has a single reason to change, and collaborates with a few other classes to achieve the desired functionality of the system.

#### Cohesion

Classes should have a small number of instance variables. Each of the methods of a class should manipulate one or more of those variables.

A class in which each variable is used by each method is maximally cohesive.

#### Maintaining Cohesion Results in Many Small Classes

### Organizing for Change

*Open/Closed Principle:* Classes should be open for extension, but closed for modification.

*Dependency Inversion Principle:* A client class depending upon concrete details is at risk when those details change. Instead of depending upon concrete details, the client should depend upon an abstraction / interface.

## Chapter 11: Systems

### Separate Constructing a System from Using It

Software systems should separate the startup process, when the application objects are constructed and the dependencies are wired together, from the runtime logic that takes over after startup.

*Lazy Initialization / Evaluation:* Doesn't incur the overhead of object construction until it is needed.

#### Separation of Main

One way to separate construction from use is simply to move all aspects of construction to `main`, or modules called by `main`, and to design the rest of the system assuming that all objects have been constructed and wired up appropriately.

The flow of control is easy to follow. The `main` function builds the objects necessary for the system, then passes them to the application, which simply uses them. Notice the direction of the dependency arrows crossing the barrier between `main` and the application. They all go one direction, pointing away from `main`. This means that the application has no knowledge of `main` or of the construction process. It simply expects that everything has been built properly.

#### Factories

Sometimes, of course, we need to make the applicaiton responsible for *when* an object gets created. In this case, we can use the Abstract Factory pattern to give the application control of when to build the objects, but keep the details of that construction separate from the application code.

#### Dependency Injection

A powerful mechanism for separating construction from use is dependency injection, the application of the *Inversion of Control* principle to dependency management. Inversion of Control moves secondary responsibilities from an object to other objects that are dedicated to the purpose, thereby supporting the Single Responsibility Principle. Because setup is a global concern, this authoritative mechanism will usually be either the `main` routine or a special-purpose *container.*

During the construction process, the DI container instantiates the required objects (usually on demand) and uses the constructor arguments or setter methods provided to wire together the dependencies. Which dependent objects are actually used is specified through a configuration file, or programmatically in a special-purpose construction module.

### Scaling Up

Software systems are unique compared to physical systems. Their architectures can grow incrementally, *if* we maintain the proper separation of concerns.

### Systems Need Domain-Specific Languages

If you are implementing domain logic in the same language that a domain expert uses, there is less risk that you will incorrectly translate the domain into the implementation. DSLs, when used effectively, raise the abstraction level above code idioms and design patterns.

## Chapter 12: Emergence

### Simple Design Rule 1: Runs All the Tests

### Simple Design Rule 2-4: Refactoring

The fact that we have these tests eliminates the feat that cleaning up the code will break it!

We can increase cohesion, decrease coupling, separate concerns, modularise system concerns, shrink our functions and classes, choose better names, and so on.

#### No Duplication

The Template Method pattern is a common technique for removing higher-level duplication.

#### Expressive

By using the standard pattern names, such as command or visitor, in the names of the classes that implement those patterns, you can succinctly describe your design to other developers.

Well-written tests are also expressive. A primary goal of tests is to act as documentation by example.

#### Minimal Classes and Methods

## Chapter 13: Concurrency

Objects are abstractions of processing. Threads are abstractions of schedule. - James O. Coplien

Concurrency is a decoupling strategy, and allows for higher throughput and lower response times.

**Misconceptions:**

- Concurrency always improves performance. It does not.
- Design does not change when writing concurrent code. It does.

### Concurrency Defence Principles

#### Single Responsibility Principle

Keep concurrency-related code separate from other code.

#### Corollary: Limit the Scope of Data

Take data encapsulation to heart; severely limit the access of any data that may be shared.

One solution is to use the `synchronized` keyword to protect a critical section in the code that uses the shared object.

It is important to restrict the number of such critical sections. The fewer places shared data can get updated, the better.

#### Corollary: Use Copies of Data

A good way to avoid shared data issues is to avoid sharing the data in the first place. In some situations it is possible to copy objects and treat them as read-only. In other cases it might be possible to copy objects, collect results from multiple threads in these copies and then merge the results in a single thread.

If using copies of objects allows the code to avoid synchronizing, the savings in avoiding the intrinsic lock will likely make up for the additional creation and garbage collection overhead.

#### Corollary: Threads Should Be as Independent as Possible

Attempt to partition data into independent subsets that can be operated on by independent threads, possibly in different processors.

### Know Your Library

- thread-safe collections
- executor framework for executing unrelated tasks
- non-blocking solutions when possible
- library modules that are not thread-safe

### Know Your Execution Models

- bound resources
- mutual exclusion
- starvation
- deadlock
- livelock

Most concurrency problems tend to be some combination of these three problems:

- Producer-Consumer
- Readers-Writers
- Dining Philosophers
-

### Keep Synchronised Sections Small

## Chapter 14: Successive Refinement

### First Make It Work

### Then Make It Right

## Chapter 17: Smells and Heuristics

### Comments

#### C1: Inappropriate Information

#### C2: Obsolete Comment

#### C3: Redundant Comment

#### C4: Poorly Written Comments

#### C5: Commented-Out Code

### Environment

#### E1: Build Requires More Than One Step

#### E2: Tests Require More Than One Step

### Functions

#### F1: Too Many Arguments

#### F2: Output Arguments

#### F3: Flag Arguments

#### F4: Dead Function

### General

#### G1: Multiple Languages in One Source File

#### G2: Obvious Behaviour Is Unimplemented

#### G3: Incorrect Behaviour at the Boundaries

#### G4: Overridden Safeties

#### G5: Duplication

#### G6: Code at Wrong Level of Abstraction

#### G7: Base Classes Depending on Their Derivatives

#### G8: Too Much Information

#### G9: Dead Code

#### G10: Vertical Separation

#### G11: Inconsistency

#### G12: Clutter

#### G13: Artificial Coupling

#### G14: Feature Envy

#### G15: Selector Arguments

#### G16: Obscured Intent

#### G17: Misplaced Responsibility

#### G18: Inappropriate Static

#### G19: Use Explanatory Variables

#### G20: Functions Should Say What They Do

#### G21: Understand the Algorithm

#### G22: Make Logical Dependencies Physical

#### G23: Prefer Polymorphism to If/Else or Switch/Case

#### G24: Follow Standard Conventions

#### G25: Replace Magic Numbers with Named Constants

#### G26: Be Precise

#### G27: Structure over Convention

#### G28: Encapsulate Conditionals

#### G29: Avoid Negative Conditionals

#### G30: Functions Should Do One Thing

#### G31: Hidden Temporal Couplings

#### G32: Don't Be Arbitrary

#### G33: Encapsulate Boundary Conditions

#### G34: Functions Should Descend Only One Level of Abstraction

#### G35: Keep Configurable Data at High Levels

#### G36: Avoid Transitive Navigation

### Java

#### J1: Avoid Long Import Lists by Using Wildcards

#### J2: Don't Inherit Constants

#### J3: Constants versus Enums

### Names

#### N1: Choose Descriptive Names

#### N2: Choose Names at the Appropriate Level of Abstraction

#### N3: Use Standard Nomenclature Where Possible

#### N4: Unambiguous Names

#### N5: Use Long Names for Long Scopes

#### N6: Avoid Encodings

#### N7: Names Should Describe Side Effects

### Tests

#### T1: Insufficient Tests

#### T2: Use a Coverage Tool

#### T3: Don't Skip Trivial Tests

#### T4: An Ignored Test Is a Question about an Ambiguity

#### T5: Test Boundary Conditions

#### T6: Exhaustively Test Near Bugs

#### T7: Patterns of Failure are Revealing

#### T8: Test Coverage Patterns Can Be Revealing

#### T9: Tests Should Be Fast
