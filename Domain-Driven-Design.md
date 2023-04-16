# [Learning Domain-Driven Design](https://github.com/vladikk/learning-ddd)

Domain-driven design (DDD) can be divided into two main parts: strategic design and tactical design. The strategic aspect of DDD deals with answering the questions of "what?" and "why?" - what software are we building and why are we building it. The tactical part is all about the "how?" - how each component is implemented.

## Strategic Design

DDD's **ubiquitous language** is an effective tool for bridging the knowledge gap between domain experts and software engineers. It fosters communication and knowledge sharing by cultivating a shared language that can be used by all the stakeholders through the project: in conversations, documentation, tests, diagrams, source code, and so on. *All of a language's terms have to be consistent, and the language has to be used consistently in all project-related communications.*

A **bounded context** defines an explicit sub-context in which a given sub-language is applied.

## Tactical Design

### Domain Model

The domain model pattern is aimed at cases of complex business logic. It consists of three main building blocks:

#### Value objects

Concepts of the business domain that can be identified exclusively by their values, and thus do not require an explicit ID field. Since a change in one of the fields semantically creates a new value, value objects are immutable.

Value objects model not only data, but behaviour as well: methods manipulating the values and thus initialising new value objects.

#### Aggregates

A hierarchy of entities sharing a transactional boundary. All of the data included in an aggregate's boundary has to be strongly consistent to implement its business logic.

The state of the aggregate, and its internal objects, can only be modified through its public interface, by executing the aggregate's commands. The data fields are read-only for external components for the sake of ensuring that all the business logic related to the aggregate resides in its boundaries.

The aggregate acts as a transactional boundary. All of its data, including all of its internal objects, has to be committed to the database as one atomic transaction.

An aggregate can communicate with external entities by publishing domain events - messages describing important business events in the aggregate's lifecycle. Other components can subscribe to the events and use them to trigger its execution of business logic.

#### Domain services

A stateless object that hosts business logic that naturally doesn't belong to any of the domain model's aggregates or value objects.

--------------------------------------------------------------------

The domain model's building blocks tackle the complexity of the business logic by encapsulating it in the boundaries of value objects and aggregates. The inability to modify the objects' state externally ensures that all the relevant business logic is implemented in the boundaries of aggregates and value objects and won't be duplicated in the application layer.

### Layered Architecture

Layered architecture organises the codebase into layers, with each layer addressing one of the following technical concerns:

- Interaction with the users (presentation layer; the programme's public interface):
  - GUI
  - CLI
  - API for programmatic integration with other systems
  - Subscription to events in a message broker
  - Message topics for publishing ongoing events
- Implementing business logic (business logic layer):
  - Entities
  - Rules
  - Processes
- Persisting the data (data access layer):
  - Databases:
    - Operational database
    - Search index for dynamic queries
    - In-memory database for performance-optimised operations
  - Message bus
  - Cloud-based object storage

The layers are integrated in a top-down communication model: each layer can hold a dependency only on the layer directly beneath it. This enforces decoupling of implementation concerns and reduces the knowledge shared between the layers.

It is common to see the layered architecture pattern extended with an additional layer: the **service layer** *acts as an orchestrator*, i.e. an intermediary between the programme's presentation and business logic layers acting as a *facade* for the business logic.

|  |  |  |  |
| --- | --- | --- | --- |
| *Presentation layer* | Web UI | CLI | REST API |
|  | $\dArr$ |  |  |
| *Service layer* | Action | Action | Action |
|  | $\dArr$ |  |  |
| *Business logic layer* | Entities | Rules | Processes |
|  | $\dArr$ |  |  |
| *Data access layer* | Database | Message bus | Object storage |

### Ports & Adapters

Applying the **dependency inversion principle (DIP)**, the business logic layer is free of dependencies (as it is at the highest level).

*Ports are interfaces, and adapters their concrete implementations* which are injected in the infrastructure layer through dependency injection or by bootstrapping.

|  |  |  |  |
| --- | --- | --- | --- |
| *Business logic layer* | Entities | Rules | Processes |
|  | $\dArr$ |  |  |
| *Application layer* | Action | Action | Action |
|  | $\dArr$ |  |  |
| *Infrastructure layer* | Database | UI framework | Message bus |

The ports & adapters architecture is also known as hexagonal architecture, onion architecture, and clean architecture:

- Application layer = service layer = use case layer
- Business logic layer = domain layer = core layer

### Command-Query Responsibility Segregation (CQRS)

In many cases, it may be difficult, if not impossible, to use a single model of the system's business domain to address all of the system's needs. For example, **online transaction processing (OLTP)** and **online analytical processing (OLAP)** may require different representations of the system's data.

Another reason for working with multiple models is the **polyglot persistence model**: using multiple databases to implement different data-related requirements. For example, a single system might use a document store as its operational database, a column store for analytics/reporting, and a search engine for implementing robust search capabilities.

Finally, the CQRS pattern is closely related to event sourcing. Originally, CQRS was defined to address the limited querying possibilities of an event-sourced model: it is only possible to query events of one aggregate instance at a time. The CQRS pattern provides the possibility of materialising projected models into physical databases that can be used for flexible querying options. That said, CQRS is useful with or without event sourcing.

#### Command Execution

The command execution model executes operations that modify the system's state (system commands) and is used to implement the business logic layer rules and to enforce invariants.

The command execution model is also the only model representing strongly consistent data - the system's source of truth. It should be possible to read the strongly consistent state of a business entity and have optimistic concurrency support when updating it.

#### Read Models (Projections)

The system can define as many models as needed to present data to users or suplly information to other systems.

A read model is a precached projection. It can reside in a durable database, flat file, or in-memory cache. Proper implementation of CQRS allows for wiping out all data of a projection and regenerating it from scratch. This also enables extending the system with additional projections in the future - models that couldn't have been foreseen originally.

Finally, read models are read-only. None of the system's operations can directly modify the read models' data.

--------------------------------------------------------------------

For the read models to work, the system has to project changes from the command execution model to all its read models, i.e. publishing changes via a projection engine to the read models.

The projection of read models is similar to the notion of a materialised view in relational databases: whenever source tables are updated, the changes have to be reflected in the precached views.

--------------------------------------------------------------------

The CQRS pattern can be useful for applications that need to work with the same data in multiple models, potentially stored in different kinds of databases. From an operational perspective, the pattern supports DDD's core value of working with the most effective models for the task at hand, and continuously improving the model of the business domain. From an infrastructural perspective, CQRS allows for leveraging the strength of the different kinds of databases; for example, using a relational datbase to store the command execution model, a search index for full text search, and pre-rendered flat files for fast data retrieval, with all the storage mechanisms reliably synchronised.

--------------------------------------------------------------------

In summary, the layered architecture decomposes the codebase based on its technological concerns. Since this pattern couples business logic with data access implementations, it's a good fit for active-record based systems.

The ports & adapters architecture inverts the relationships: it puts the business logic at the centre and decouples it from all infrastructural dependencies. This pattern is a good fit for business logic implemented with the domain model pattern.

The CQRS pattern represents the same data in multiple models. Although this pattern is obligatory for systems based on the event-sourced domain model, it can also be used in any systems that need a way of working with multiple persistent models.

### Analytical Data Model vs Transactional Data Model

DWH, data lake, data mesh vs database
