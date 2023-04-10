# [Architecture Patterns with Python: Enabling Test-Driven Development, Domain-Driven Design, and Event-Driven Microservices](https://github.com/millengustavo/python-books/blob/master/architecture-patterns-python/notes.md)

## Part I. Building an Architecture to Support Domain Modelling

- The Repository pattern, an abstraction over the idea of persistent storage
- The Service Layer pattern to clearly define where our use cases begin and end
- The Unit of Work pattern to provide atomic operations
- The Aggregate pattern to enforce the integrity of our data

For example, Flask invokes the Service Layer. The Service Layer starts a Unit of Work, and calls a method on the Domain. The Unit of Work provides Adapters, i.e. a Repository. The Repository commits changes to the DB, thus loading to or saving from the Domain.

### Chapter 1. Domain Modelling

The **domain** is the part of your code that is closest to the business, the most likely to change, and the place where you deliver the most value to the business. Make it easy to understand and modify.

For example, a method on the Domain could be to allocate an order line to a batch:

```python
@dataclass(frozen=True)
class OrderLine:
    order_id: str
    sku: str
    qty: int

class Batch:
    def __init__(self, ref: str, sku: str, qty: int, eta: Optional[date]):
        self.reference = ref
        self.sku = sku
        self.eta = eta
        self.available_quantity = qty

    def allocate(self, line: OrderLine):
        self.available_quantity -= line.qty
```

Exceptions can express domain concepts too:

```python
class OutOfStack(Exception):
    pass

def allocate(line: OrderLine, batches: Sequence[Batch]) -> str:
    try:
        batch = next(...)
    except StopIteration:
        raise OutOfStock(f"Out of stock for sku {line.sku})"
```

Distinguish entities from value objects:

- A **value object** is defined by its attributes. It's usually best implemented as an immutable type, i.e. a `frozen dataclass` or `namedtuple`. If you change an attribute on a value object, it represents a different object.

```python
@dataclass(frozen=True)
class Money:
    currency: str
    value: int

class Money(NamedTuple):
    currency: str
    value: int
```

- In contrast, an **entity** has attributes that may vary over time and it will still be the same entity. It's important to define what *uniquely identifies* an entity (usually an ID, name or reference field).

```python
class Person:
    def __init__(self, name: Name):
        self.name = name
```

Entities, unlike values, have *identity equality:* we can change their values, and they are still the same thing.

```python
class Batch:
    ...

    def __eq__(self, other):
        if not isinstance(other, Batch):
            return False
        
        return other.reference == self.reference

    def __hash__(self):
        return hash(self.reference)
```

Not everything has to be an object: Let the "verbs" in your code be functions. For every `FooManager`, `BarBuilder` or `BazFactory`, there's often a more expressive and readable `manage_foo()`, `build_bar()` or `get_baz()` waiting to happen.

This is the time to apply your best OO design principles: Revisit the SOLID principles and all the other good heuristics like "has-a versus is-a", "prefer composition over inheritance", and so on.

### Chapter 2. The Repository Pattern

#### Dependency Inversion Principle (DIP)

High-level modules (the domain) should not depend on low-level ones (the infrastructure).

#### Apply dependency inversion to the ORM

The domain model should be free of infrastructure concerns; the ORM should import the model, and not the other way around.

#### Repository Pattern

Depend on an `Abstract Repository` that implements a `Concrete Repository` able to query the DB.

#### Ports and Adapters

The interface is called the Port, and the implementation is called the Adapter.

The Repository pattern is a simple abstraction around permanent storage: The repository gives you the illusion of a collection of in-memory objects.

Building a fake repository for tests without disrupting the core application is now trivial!

### Chapter 3. On Coupling and Abstractions

Abstractions reduce coupling and aid testability.

Why not just patch it out?

- Patching out the dependency you're using makes it possible to unit test the code, but it does nothing to improve the design. Using `mock.patch` won't let your code work with a `--dry-run` flag, nor will it help you run against an FTP server. For that, you'll need to introduce abstractions.
- Tests that use mocks *tend* to be more coupled to the implementation details of the codebase. That's because mock tests verify the interactions between things: did we call `shutil.copy` with the right arguments? This coupling between code and tests *tends* to make tests more brittle, in our experience.
- Overuse of mocks leads to complicated test suites that fail to explain the code.

### Chapter 4. Flask API and Service Layer

```txt
.
|-- config.py
|-- domain
|   |-- __init__.py
|   |-- model.py
|-- services
|   |-- __init__.py
|   |-- service.py
|-- adapters
|   |-- __init__.py
|   |-- orm.py
|   |-- repository.py
|-- api
|   |-- __init__.py
|   |-- flask.py
|-- tests
    |-- __init__.py
    |-- conftest.py
    |-- unit
    |   |-- test_allocate.py
    |   |-- test_batches.py
    |   |-- test_services.py
    |-- integration
    |   |-- test_orm.py
    |   |-- test_repository.py
    |-- e2e
    |   |-- test_api.py
```

The API endpoints become very thin and easy to write: their only responsibility is doing "web stuff", such as parsing JSON and producing the right HTTP codes for happy or unhappy cases.

The domain has a clearly defined API, a set of use cases or entrypoints that can be used by any adapter without needing to know anything about the domain model classes - whether that's an API, a CLI, or the tests! They're an adapter for the domain too.

Tests can be written in "high gear" by using the service layer, leaving us to free to refactor the domain model in any way we see fit. As long as we can still deliver the same use cases, we can experiment with new designs without needing to rewrite a load of tests.

### Chapter 5. TDD in High Gear and Low Gear

We still have direct dependencies on the domain in the service-layer tests, because we use domain objects to set up the test data and to invoke the service-layer functions.

Mitigation: *keep all domain dependencies in fixture functions*

Rules of thumbs:

- **Aim for one end-to-end test per feature:** This might be written against a HTTP API, for example. The objective is to demonstrate that the feature works, and that all the moving parts are glued together correctly.
- **Write the bulk of your tests against your service layer:** These edge-to-edge tests offer a good trade-off between coverage, runtime, and efficiency. Each test tends to cover one code path of a feature and use fakes for I/O. This is the place to exhaustively cover all the edge cases and the ins and outs of your business logic.
- **Maintain a small core of tests written against your domain model:** These tests have highly focused coverage and are more brittle, but they have the highest feedback. Don't be afraid to delete these tests if the functionality is later covered by tests at the service layer.
- **Error handling counts as a feature:** Ideally, your application will be structured such that all errors that bubble up to your entrypoints (e.g., Flask) are handled in the same way. This meaans you need to test only the happy path for each feature, and to reserve one end-to-end test for all unhappy paths (and many unhappy path unit tests, of course).

### Chapter 6. Unit of Work Pattern

#### *The Unit of Work pattern is an abstraction around data integrity*

It helps to enforce the consistency of the domain model, and improves performance, by letting us perform a single `flush` operation at the end of an operation.

#### *It works closely with the Repository and Service Layer patterns*

The Unit of Work pattern completes our abstractions over data access by representing atomic updates. Each of our service-layer use cases runs in a single unit of work that succeeds or fails as a block.

#### *This is a lovely case for a context manager*

Context managers are an idiomatic way of defining scope in Python. We can use a context manager to automatically roll back our work at the end of a request, which means the system is safe by default.

#### *SQLAlchemy already implements this pattern*

We introduce an even simpler abstraction over the SQLAlchemy `Session` object in order to "narrow" the interface between the ORM and your code. This helps to keep us loosely coupled.

### Chapter 7. Aggregates and Consistency Boundaries

#### *Aggregates are your entrypoints into the domain model*

By restricting the number of ways that things can be changed, we make the system easier to reason about.

For example, instead of allocating an order line to a batch, we could introduce a `Product` aggregate that will do so.

#### *Aggregates are in charge of a consistency boundary*

An aggregate's job is to be able to manage our business rules about invariants as they apply to a group of related objects. It's the aggregate's job to check that the objects within its remit are consistent with each other and with our rules, and to reject changes that would break the rules.

#### *Aggregates and concurrency issues go together*

When thinking about implementing these consistency checks, we end up thinking about transactions and locks. Choosing the right aggregate is about performance as well as conceptual organisation of your domain.

## Part II. Event-Driven Architecture

- Domain events trigger workflows that cross consistency boundaries.
- The message bus provides a unified way of invoking use cases from any endpoint.
- CQRS separates reads and writes to avoid awkward compromises in an event-driven architecture and enables performance and scalability improvements.

### Chapter 8. Events and the Message Bus

#### *Events can help with the single responsibility principle*

Code gets tangled up when we mix multiple concerns in one place. Events can help us to keep things tidy by separating primary use cases from secondary ones. We also use events for communicating between aggregates so that we don't need to run long-running transactions that lock against multiple tables.

#### *A message bus routes messages to handlers*

You can think of a message bus as a `dict` that maps from events to their consumers. It doesn't "know" anything about the meaning of events; it's just a piece of dumb infrastructure for getting messages around the syteem.

#### *Option 1: Service layer raises events, service layer passes them to message bus*

The simplest way to start using events in your system is to raise them from handlers by calling `bus.handle(some_new_event)` after you commit your unit of work.

#### *Option 2: Domain model raises events, service layer passes them message bus*

The logic about when to raise an event really should live with the model, so we can improve our system's design and testability by raising events from the domain model. It's easy for our handlers to collect events off the model objects after `commit` and pass them to the bus.

#### *Option 3: UoW collects events from aggregates and passes them to message bus*

Adding `bus.handle(aggregate.events)` to every handler is annoying, so we can tidy up by making our unit of work responsible for raising events that were raised by loaded objects. This is the most complex design and might rely on ORM magic, but it's clean and easy to use once it's set up.

## Appendix A. A Summary Diagram and Table

| Layer | Component | Description |
| --- | --- | --- |
| **Domain** defines the business logic | Entity | A domain object whose attributes may change but that has a recognisable identity over time |
|| Value object | An immutable domain object whose attributes entirely define it. It if fungible with other identical objects. |
|| Aggregate | Cluster of associated objects that we treat as a unit for the purpose of data changes. Defines and enforces a consistency boundary. |
|| Event | Represents something that happened. |
| Command | Represents a jbo the system should perform. |
| **Service Layer** defines the jobs  the system should perform and orchestrates different components | Unit of work | Abstraction around data integrity. Each unit of work represents an atomic update. Makes repositories available. Tracks new events on retrieved aggregates. |
|| Message bus (internal) | Handles commands and events by routing them to the appropriate handler. |
| **Adapters** (secondary) are the concrete implementations of an interface that goes from the system to the outside world (I/O) | Repository | Abstraction around persisten storage. Each aggregate has its own repository. |
|| Event publisher | Pushes events onto the external message bus. |
| **Entrypoints** (primary adapter) translate external inputs into calls into the service layer | Web | Receives web requests and translates them into commands, passing them to the internal message bus. |
|| Event consumer | Reads events from the external message bus and translates them into commands, passing them to the internal message bus. |
| N/A | External message bus (message broker) | A piece of infrastructure that different services use to intercommunicate, via events. |
