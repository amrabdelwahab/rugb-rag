# RAG-based Document Retrieval System

This repository implements a **Retrieval-Augmented Generation (RAG)** system using Ruby on Rails. The application allows users to upload documents, chunk them into manageable parts, generate embeddings, and store these in a vector database for fast and relevant retrieval. This project uses Docker for containerized development. This application is built for the purpose of a demo in Ruby user group berlin

## Features

- **Document Upload**: Upload and manage PDF documents.
- **Chunking and Embedding**: Automatically chunk documents into smaller sections and generate embeddings.
- **Vector Database**: Stores embeddings in a postgres database with pgvector extension for efficient retrieval.
- **Query-Based Retrieval**: Allows users to query the stored documents for relevant information using embeddings.

## Technologies

- **Ruby on Rails**: Backend framework.
- **pgvector**: PostgreSQL extension for vector similarity search.
- **Docker**: Containerization for development and deployment.
- **Sidekiq**: Background job processing for asynchronous chunking and embedding.
- **Redis**: Queue storage for Sidekiq.
- **RSpec**: Testing framework for Ruby.

## Setup Instructions

1. **Clone the repository**:

   ```bash
   git clone <repo-url>
   cd <repo-name>
   ```

2. **Environment Variables**: Copy .env.dev.template to `.env.dev` files as needed. Ensure you have environment variables openAI key.

3. **Makefile Commands**: Use the Makefile for easy setup and development management.

   - **Set up the development environment**:

     ```bash
     make setup
     ```

   - **Run the development server**:

     ```bash
     make up
     ```

4. **Access the Application**: Once the server is running, access the application at `http://localhost:3000`.

## Makefile Commands

The following commands are available via the Makefile:

| Command                | Description                                                                                       |
| ---------------------- | ------------------------------------------------------------------------------------------------- |
| `make setup`           | Initializes everything (builds images, installs gems, creates the database, and runs migrations). |
| `make build`           | Builds the Docker image.                                                                          |
| `make bundle`          | Installs missing gems.                                                                            |
| `make db-migrate`      | Runs migrations for the development database.                                                     |
| `make db-test-migrate` | Runs migrations for the test database.                                                            |
| `make dev`             | Opens a shell inside the running container.                                                       |
| `make up`              | Starts the development server.                                                                    |
| `make tear-down`       | Stops and removes all containers.                                                                 |
| `make stop`            | Stops the server.                                                                                 |
| `make rspec`           | Runs the RSpec test suite.                                                                        |
| `make console`         | Opens the Rails console.                                                                          |
| `make db-create`       | Creates the development and test databases.                                                       |
| `make test`            | Runs the RSpec test suite (alias for `make rspec`).                                               |

## Testing

Run tests with:

```bash
make test
```

## Development Tips

- **Start a shell inside the container**:

  ```bash
  make dev
  ```

- **Run migrations**:

  ```bash
  make db-migrate
  ```

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Create a new Pull Request.

---

This README provides an overview, setup guide, command reference, and structure details, ensuring easy setup and usage for developers. Let me know if you need further customization!
