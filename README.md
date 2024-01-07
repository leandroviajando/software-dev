# Software Development Resources

## Dependency Management

- [Poetry](https://muttdata.ai/blog/2020/08/21/a-poetic-apology.html)
- [Poetry with Private Repos (e.g. Artifactory)](https://github.com/python-poetry/poetry/issues/4389)

```bash
private-package = {version = "^0.1.0", source = "artifactory"}

[[tool.poetry.source]]
name = "artifactory"
secondary = true
url = "https://artifactory.whatever.com/artifactory/some-repository/"
```

## Data Versioning

- [Build a Reproducible and Maintainable Data Science Project](https://khuyentran1401.github.io/reproducible-data-science)
- [Data Version Control](https://mathdatasimplified.com/2023/02/20/introduction-to-dvc-data-version-control-tool-for-machine-learning-projects-2/)
- [Git-LFS](https://www.youtube.com/watch?v=xPFLAAhuGy0)

```bash
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.python.sh | bash
pip install git-lfs

git init
git lfs install

git lfs track "*.pickle"
```

## Numerical Computing Techniques

- [Iterating over pd.DataFrame](https://towardsdatascience.com/efficiently-iterating-over-rows-in-a-pandas-dataframe-7dd5f9992c01)

## RegEx

- [English to RegEx](https://www.autoregex.xyz/)

## Testing

- [Pytest](https://towardsdatascience.com/pytest-for-data-scientists-2990319e55e6)
- [mock and patch](https://write.agrevolution.in/python-unit-testing-mock-and-patch-8ba9c796c9c2)
- Test Doubles:
  - A **dummy** is a placeholder to fill some required parameters.
  - A **fake** simulates a real dependency with a simplified working implementation.
  - A **stub** behaves exactly as instructed.
  - A **spy** records interactions with the production code, allowing tests to extract the interaction history when required.
  - A **mock** additionally includes assertions (expectations) about the interactions with the production code.

## Software Design

- [Clean Code](https://testdriven.io/blog/clean-code-python/)
- [OOP](https://www.pythontutorial.net/python-oop/)
- [Inheritance and Composition](https://realpython.com/inheritance-composition-python/)
- [Domain-Driven Design](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice):
  - Ubiquitous Language: Creating a shared vocabulary and terminology that both developers and domain experts can use to discuss the domain.
  - Bounded Contexts: Defining specific boundaries around parts of the domain to isolate them and manage complexity.
  - Entities and Value Objects: Modeling domain entities and value objects that represent key concepts in the domain.
  - Aggregates: Clustering related entities and value objects together to enforce consistency and invariants.
  - Repositories: Providing a structured way to access and persist domain objects.
- [Hexagonal Architecture (a.k.a. Ports & Adapters)](https://alistair.cockburn.us/hexagonal-architecture/):
  - separate business logic (the hexagon) from its external dependencies (the ports & adapters)
  - this separation allows for improved flexibility and testability
- Event Sourcing:
  - Events: Immutable records of something that has happened in the system. Events capture both state changes and the intent behind those changes.
  - Event Store: A data store that stores the events in an append-only fashion.
  - Projections: Mechanisms to build read models (current state) from the event stream for querying purposes.
  - Event Handlers: Components responsible for updating the read models in response to events.
- Command-Query Responsibility Segretation (CQRS):
  - Command Handlers: Components responsible for processing commands and updating the write-side (event sourcing) of the system.
  - Query Handlers: Components responsible for handling queries and providing data from the read-side (projections) of the system.
  - Command and Query Models: These are often distinct from each other, tailored to the specific needs of commands and queries.

### APIs

- [FastAPI ML Serving](https://luis-sena.medium.com/how-to-optimize-fastapi-for-ml-model-serving-6f75fb9e040d)
- [FastAPI Design Patterns](https://theprimadonna.medium.com/5-must-know-design-patterns-for-building-scalable-fastapi-applications-36f9f31059fd)
- [FastAPI Three-Layer Architecture](https://medium.com/@yashika51/write-robust-apis-in-python-with-three-layer-architecture-fastapi-and-pydantic-models-3ef20940869c)
- [Metaprogramming with Decorators](https://medium.com/@angusyuen/writing-maintainable-pythonic-code-metaprogramming-with-decorators-2fc2f1d358db)
