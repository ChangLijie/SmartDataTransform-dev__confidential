# AIXtract

**AIXtract** is a modular library designed to support Retrieval-Augmented Generation (RAG) pipelines by providing flexible parsing tools for complex data sources. It enables users to ingest various types of input (e.g., PDFs, XML, raw text), transform them into a unified intermediate format, and evaluate the transformation quality using configurable metrics.

This toolkit is especially useful for building RAG pipelines where consistency and minimal information loss during document transformation are critical.

---

# 🧑‍💻 For Developers

## 📑 Agenda

- [🧩 Module Architecture Overview](#-module-architecture-overview)
- [🚧 Development Workflow](#-development-workflow)
    - [🔀 Branching Strategy](#-branching-strategy)
    - [📌 Developer Custom Method](#-developer-custom-method)
    - [🧪 Unit Test ](#-unit-test)
    - [📦 Package  ](#-packaging)
    - [📝 CHANGELOG Management](#-changelog-management)
    - [🚀 Release ](#-release)
## 🧩 Module Architecture Overview
This library is organized into modular components, each with a clearly defined role and interface. Below is a high-level summary of each core module for developers:

| Module          | Responsibility |
|-----------------|----------------|
| **`converter/`**     | **Unified entry point for data transformation.**<br>It receives raw or preprocessed data and transforms it, typically via LLM (e.g., summarization). All LLM integrations or custom transformation logic are handled here. |
| **`evaluator/`**     | **Entry point for evaluation.**<br>It accepts ground truth (`gt`) and generated data (`data`), along with a chosen metric, and calculates the similarity score. |
| **`metrics/`**       | **Implements similarity algorithms.**<br>Includes methods like string similarity, etc. Used by the evaluator for scoring. |
| **`preprocessor/`**  | **Handles text preprocessing.**<br>Cleans, segments, and formats the output from `readers` before it's sent to the converter. |
| **`readers/`**       | **Implements various data parsers.**<br>Extracts and structures data from sources such as PDF or XML using base readers like `XMLParser`. |
| **`example/`** | **Usage examples and integration demos** |
| **`tests/`** | **Unit tests** and regression coverage |
| **`utils/`** | Helper functions and shared tools |
---
## 🚧 Development Workflow

To contribute or develop new features, please follow the branching and release policy below:

### 🔀 Branching Strategy

1. **Create a new feature branch from `main`**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feat/your-feature-name
3. **Entry dev env**
    ```
    sudo ./dev.sh
    ```
2. **Develop and commit your changes locally** 
3. **Merge into `dev` first for integration testing.
    ```bash
    git checkout dev
    git merge feat/your-feature-name
    git push origin dev
    ```
4. **Once `dev` is stable, open a Pull Request to `main` for release**
    * Assign a reviewer
    * Ensure all tests pass
    * Describe the change clearly

### 📌 Developer Custom Method

- Each module contains a base abstract class (`BaseReader`, `BaseMetric`, etc.) which defines the required interface for that component.
- When extending functionality:
  - ✅ Inherit from the appropriate base class
  - ✅ Implement required methods (e.g., `.convert()`, `.calculate()`)
  - ✅ Place it in the corresponding module folder
  - ✅ Optionally register it in a factory or Enum dispatcher
- The system is designed to be **modular, extensible, and loosely coupled**, allowing plug-and-play for new models, formats, and metrics.

---

### 🧪 Unit Test

Before packaging the project, all developers are required to write and run unit tests using `pytest`.

The test files are organized under the `tests/` directory, and should follow the naming convention `test_*.py`.
#### ✅ Test Folder Structure Example
```bash
tests/
├── data/
├── pdf2json/
│ ├── test_converter.py
│ ├── test_evaluator.py
│ ├── test_pdf_parser.py
│ ├── test_preproc.py
│ └── test_xml_parser.py
```
#### 🚀 Running Tests
To run all tests:
```bash
PYTHONPATH=. pytest tests/
```
To run a specific test file:
```bash
PYTHONPATH=. pytest tests/pdf2json/test_pdf_parser.py
```

### 📦 Package
To build the project, please run the following command:

```bash
python3 packages/package.py
```
This script will compile and package the project into .so modules.

If you need to change the modules to include or exclude in the build, modify the following parameters in package.py:

MODULE_LIST: List of module folders to include in the build.

EXCLUDE_DIRS: List of directories to exclude from the build process.

After a successful build, the output will be generated under the packages/ directory in the following structure:
```bash
packages/
└── AIXtract/
    ├── readers/
    │   └── pdfparser.so
    ├── utils/
    │   └── ...
```


### 📝 CHANGELOG Management
✅ Important: Before merging into main, update CHANGELOG.md
    This is required because our CI/CD pipeline uses it for versioning and deployment.
Each version update in CHANGELOG.md should follow this format:

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
```
## [x.x.x] - yyyy-mm-dd
### Added
- ...

### Fixed
- ...

### Changed
- ...

```

### 🚀 Release 
To publish a new release, follow these steps:

1. Check the CHANGELOG.md file using the Keep a Changelog format.

    Example:

    ```bash
    ## [x.x.x] - yyyy-mm-dd
    ### Added
    - ...
    ```
2. Navigate to your GitHub repository → click on the `Actions` tab.

3. Find the workflow named `Build release`.

4. Click `Run workflow` to manually trigger the release pipeline.

5. Once triggered, the workflow will automatically:

    * Install dependencies

    * Compile the project using Cython

    * Run unit tests via Pytest

    * Extract the latest entry from CHANGELOG.md as the release notes

    * Create a GitHub Release with an auto-generated tag

    * Build and push a multi-platform Docker image to Docker Hub

