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
```

## Numerical Computing Techniques

- [Iterating over pd.DataFrame](https://towardsdatascience.com/efficiently-iterating-over-rows-in-a-pandas-dataframe-7dd5f9992c01)

## RegEx

- [English to RegEx](https://www.autoregex.xyz/)

## Testing

- [Pytest](https://towardsdatascience.com/pytest-for-data-scientists-2990319e55e6)
- [mock and patch](https://write.agrevolution.in/python-unit-testing-mock-and-patch-8ba9c796c9c2)

## Software Design

- [Clean Code](https://testdriven.io/blog/clean-code-python/)
- [Domain-Driven Design](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice)
- [OOP](https://www.pythontutorial.net/python-oop/)
- [Inheritance and Composition](https://realpython.com/inheritance-composition-python/)

### APIs

- [FastAPI Design Patterns](https://theprimadonna.medium.com/5-must-know-design-patterns-for-building-scalable-fastapi-applications-36f9f31059fd)
- [FastAPI Three-Layer Architecture](https://medium.com/@yashika51/write-robust-apis-in-python-with-three-layer-architecture-fastapi-and-pydantic-models-3ef20940869c)
- [Metaprogramming with Decorators](https://medium.com/@angusyuen/writing-maintainable-pythonic-code-metaprogramming-with-decorators-2fc2f1d358db)
