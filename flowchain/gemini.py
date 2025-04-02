import base64
import os
from google import genai
from google.genai import types


def generate():
    client = genai.Client(
        api_key=os.environ.get("GEMINI_API_KEY"),
    )

    files = [
        # Please ensure that the file is available in local system working direrctory or change the file path.
        client.files.upload(file="cody-chat-history-2025-03-28T16-13-05.json"),
        # Please ensure that the file is available in local system working direrctory or change the file path.
        client.files.upload(file="cody-chat-history-2025-04-02T03-13-54.json"),
    ]
    model = "gemini-2.5-pro-exp-03-25"
    contents = [
        types.Content(
            role="user",
            parts=[
                types.Part.from_uri(
                    file_uri=files[0].uri,
                    mime_type=files[0].mime_type,
                ),
                types.Part.from_uri(
                    file_uri=files[1].uri,
                    mime_type=files[1].mime_type,
                ),
                types.Part.from_text(text="""Can you help me create scaffolding and background coding for the foundation of a multi-agent system? I would like to use an architecture that comes from GitHub’s Well-Architected project, and I need to take into account the chatGPT sandbox, chrome OS sandbox, and the tunneling that goes between them. It also must include full coding, Cloudflare and GitHub integration, and an outline.

I need to set up this system so that my custom GPT agent starts by receiving input from the Omnibox in chatGPT. That input then goes through the GPT logic and into the tunnel. Based on logic, the custom GPTs on the other side are called by need, use tools and functions to answer the query, and then the information is given through the tunnel to the orchestrator. The orchestrator gives the answer, but all of this is done in parallel or async, so I can offload some of the duties to increase speed and accuracy."""),
            ],
        ),
        types.Content(
            role="model",
            parts=[
                types.Part.from_text(text="""Here's a breakdown of the thought process to generate the scaffolding for the multi-agent system:

1.  **Deconstruct the Request:**

    *   **Goal:** Create scaffolding and background code for a multi-agent system.
    *   **Architecture:** Use GitHub's Well-Architected Framework (WAF) principles.
    *   **Context:** Operate within constraints of ChatGPT sandbox, ChromeOS sandbox, and a tunnel between them.
    *   **Core Flow:** ChatGPT Omnibox -> Custom GPT Logic -> Tunnel -> Backend Agents (LangGraph/Flow) -> Tunnel -> Orchestrator -> ChatGPT Response.
    *   **Features:**
        *   Full coding examples.
        *   Cloudflare integration (likely for tunneling/security).
        *   GitHub integration (likely for CI/CD, code management).
        *   Outline of the structure.
        *   Parallel/async processing for speed and offloading.
    *   **Key Components Mentioned:** Tunnel, Custom GPTs (plural), Orchestrator, Tools, Functions.

2.  **Identify Core Challenges & Constraints:**

    *   **Sandboxing:** ChatGPT and ChromeOS have strict limitations. Direct process execution, network calls (outside specific allowances for GPT Actions/Plugins), and file system access are restricted from the ChatGPT side. This *necessitates* the \"tunnel.\"
    *   **Tunneling:** This is the critical link. How does it work? Likely an API endpoint exposed by the backend, potentially secured/proxied by Cloudflare. The frontend (ChatGPT custom GPT/Action) needs to call this API.
    *   **State Management:** How is conversation state maintained between the stateless ChatGPT frontend and the stateful backend? The tunnel API needs to handle session IDs or context passing.
    *   **Well-Architected Framework (WAF):** This implies thinking about security, reliability, performance efficiency, cost optimization, and operational excellence *throughout* the design.
    *   **Multi-Agent Logic:** The request mentions *multiple* custom GPTs on the backend. This strongly suggests a LangGraph-like structure where different agents/nodes handle specific tasks.
    *   **Parallelism/Async:** Key requirement. LangGraph inherently supports this, but the API design for the tunnel must also accommodate it (e.g., accepting tasks and returning immediately, potentially with a task ID for status checks or using WebSockets/Server-Sent Events for updates).

3.  **Outline the Architecture (High-Level):**

    *   **Frontend (ChatGPT/ChromeOS):**
        *   ChatGPT UI (Omnibox)
        *   Custom GPT Action/Plugin: Captures input, calls the Tunnel API. Handles displaying the final response.
    *   **Tunneling Layer (Cloudflare):**
        *   Cloudflare Tunnel/Worker/Access: Securely exposes the backend API, handles authentication/authorization.
    *   **Backend (Server/Cloud Function/Container):**
        *   API Endpoint (FastAPI/Flask): Receives requests from the tunnel.
        *   `AgentCore`/`GPTTunnelBridge`: Entry point, initial request handling, potentially calls backend GPT for routing/preprocessing.
        *   LangGraph Executor: Runs the multi-agent workflow.
            *   State Definition (`AgentState`)
            *   Nodes (Memory, Tools, Sub-Agents, Approval, State Updates, Response Generation)
            *   Edges (Conditional routing)
        *   Supporting Modules (Memory, Tools, Governance, State Repo, Config, Models)
    *   **External Services:** LLMs (OpenAI via API), Vector DBs, Payment Gateways, etc.
    *   **DevOps/Infrastructure:** GitHub (Repo, Actions), Docker, potentially K8s/Serverless.

4.  **Choose the Right Framework:**

    *   LangChain is foundational, but LangGraph is explicitly designed for multi-agent, stateful, cyclic workflows. The request's description (multiple agents, orchestrator, parallel processing) aligns perfectly with LangGraph. So, prioritize LangGraph for the core backend logic.

5.  **Design Key Components (Code Scaffolding):**

    *   **`pyproject.toml`:** Define dependencies (FastAPI, Uvicorn, LangGraph, LangChain, Pydantic, Cloudflare client if needed, etc.).
    *   **Directory Structure:** Organize logically based on WAF principles (separation of concerns). Use `src/flow/...` for the core library. Include `api`, `graph`, `memory`, `tools`, `state`, `governance`, `human`, `config`, `models`. Add `tests`, `examples`, `Dockerfile`, `docker-compose.yml`.
    *   **Configuration (`config.py`):** Use Pydantic `BaseSettings` to load from `.env`. Include API keys, DB URIs, model names, etc.
    *   **API Layer (`api/service.py`):** Use FastAPI. Define request/response models (Pydantic). Create an endpoint (e.g., `/process`) to receive requests from the tunnel. *Crucially*, this endpoint needs to handle session/conversation IDs. It will likely initiate the LangGraph run. Consider async endpoints.
    *   **Tunnel Interface (`GPTTunnelBridge.py` or similar):** This acts as the immediate backend handler called by the API. It parses the request, potentially interacts with a *routing* LLM if needed, prepares the initial `AgentState`, and invokes the main LangGraph application (`FlowApplication` or `AgentCore`). *Self-correction:* The previous `AgentCore` and `GPTTunnelBridge` might be merged or simplified. The FastAPI endpoint *is* the bridge. Let's rename `AgentCore` to `FlowApplication` to represent the main LangGraph app.
    *   **LangGraph State (`state/schema.py`):** Define the `AgentState` `TypedDict`. Include fields for messages, working memory, specific task states (like order details), pending actions, errors, etc.
    *   **LangGraph Nodes (`graph/nodes/...`):** Create Python functions or classes for each logical step:
        *   `call_model`: Interacts with LLMs (routing, response generation).
        *   `call_tool`: Executes specific tools (using the `ToolExecutor`). Needs error handling.
        *   `update_memory`: Saves/retrieves from different memory types.
        *   `check_approval`: Handles human-in-the-loop logic.
        *   `update_state_db`: Persists critical state changes.
    *   **LangGraph Edges (`graph/edges.py`):** Define conditional logic (e.g., `should_continue`, `route_action`) based on the `AgentState`.
    *   **LangGraph Builder (`graph/builder.py`):** Assemble the nodes and edges into the `StateGraph`. Compile it into a runnable `CompiledGraph`.
    *   **Main Application (`app.py`):** Initialize all components (config, memory, tools, state repo, graph) and provide the main method to run the graph (`invoke` or `stream`).
    *   **Tool Definitions (`tools/definitions/...`):** Implement the actual tool logic (e.g., `payment.py`, `order.py`). Use Pydantic for input schemas.
    *   **Memory Implementations (`memory/...`):** Flesh out the different memory types, potentially adding database persistence for episodic/semantic memory.
    *   **Cloudflare Tunnel Setup:** This is infrastructure, not code *within* the app, but needs mentioning. Use `cloudflared` or Cloudflare dashboard to expose the backend API service (e.g., the FastAPI app running on port 8000).
    *   **ChatGPT Action/Plugin:** Define the OpenAPI schema for the custom GPT Action. This schema will describe the `/process` endpoint on the backend (exposed via the Cloudflare tunnel). The *implementation* of the custom GPT itself (instructions, conversation starters) lives in the ChatGPT UI.

6.  **Refine and Elaborate:**

    *   **Async/Parallel:** Emphasize `async def` for nodes and API endpoints. LangGraph handles the scheduling. Mention that tool calls *can* be made parallel if they are independent.
    *   **Error Handling:** Add `try...except` blocks in tool execution and graph nodes. Update the `AgentState` with errors.
    *   **Security:** Mention Cloudflare Access for authentication at the tunnel entry point. Input sanitization is crucial. Don't use `eval()` carelessly (as seen in placeholder policy checks – replace with safer logic).
    *   **GitHub Integration:** Add notes about using GitHub Actions for CI/CD (testing, linting, building Docker images, deploying).
    *   **Code Examples:** Provide *runnable* (though potentially simplified) code for key parts like the FastAPI endpoint, a LangGraph node, the state definition, and the graph builder. Use placeholders (`# TODO: Implement...`) where full logic is too complex for scaffolding.
    *   **Clarity:** Structure the answer logically with clear headings. Use code blocks correctly formatted. Explain *why* each component exists and how it fits into the WAF principles. Acknowledge the complexity and iterative nature.

7.  **Final Review:** Does the generated scaffolding address all parts of the original request? Is it logical? Is it well-structured? Does it account for the sandbox/tunnel constraints? Is the LangGraph approach clear? Is the integration with the custom GPT/tunnel explained?"""),
                types.Part.from_text(text="""Okay, let's design the scaffolding for your multi-agent system, integrating your custom GPT logic, the \"tunnel\" concept, LangGraph for the backend orchestration, and adhering to Well-Architected principles, including Cloudflare and GitHub integration points.

**Core Concepts:**

1.  **Frontend (ChatGPT):** The Custom GPT within ChatGPT acts as the user interface and initial interaction point. It uses a GPT Action.
2.  **Tunnel (Cloudflare):** A secure pathway (likely Cloudflare Tunnel + API endpoint) connecting the ChatGPT Action to your backend. Cloudflare Access can secure this.
3.  **Backend API (FastAPI):** Receives requests from the tunnel, authenticates, and initiates the LangGraph workflow.
4.  **Backend Orchestration (LangGraph):** Manages the stateful, multi-agent workflow, calling tools, sub-agents (potentially other LLM calls), memory systems, etc.
5.  **Well-Architected Principles:** Applied through modular design, clear state management, security via Cloudflare, potential for monitoring, and CI/CD via GitHub Actions.
6.  **Async/Parallel:** FastAPI and LangGraph are inherently async, allowing for non-blocking I/O and potential parallel tool execution within the graph.

**Outline & Architecture Diagram:**

```mermaid
graph TD
    A[User @ ChatGPT Omnibox] --> B(Custom GPT Action);
    B -- HTTPS Request via Tunnel --> C{Cloudflare Tunnel/Access};
    C -- Secured Forwarding --> D[Backend API Endpoint (FastAPI)];
    D -- Invoke Graph --> E[LangGraph Executor];
    E -- Manages State --> F(Agent State);
    E -- Calls Nodes --> G{Graph Nodes};
    G -- Memory Ops --> H[Memory System (Unified)];
    G -- Tool Execution --> I[Tool Executor];
    I -- Calls --> J[External Tools/APIs/DBs];
    G -- Sub-Agent Logic --> K[LLM Calls (Backend GPTs)];
    G -- Human Approval --> L[Approval System];
    E -- Sends Response --> D;
    D -- HTTPS Response via Tunnel --> C;
    C -- Secured Forwarding --> B;
    B --> M(Response to User @ ChatGPT);

    subgraph \"Frontend (ChatGPT/ChromeOS Sandbox)\"
        A
        B
    end

    subgraph \"Tunneling & Security (Cloudflare)\"
        C
    end

    subgraph \"Backend (Your Server/Cloud)\"
        D
        E
        F
        G
        H
        I
        J
        K
        L
    end

    style E fill:#f9f,stroke:#333,stroke-width:2px
    style D fill:#ccf,stroke:#333,stroke-width:2px
    style C fill:#f80,stroke:#333,stroke-width:2px
```

**Project Scaffolding (Directory Structure):**

```
flow-system/
├── pyproject.toml           # Project dependencies (Poetry or setup.py)
├── Dockerfile               # For containerization
├── docker-compose.yml       # For local development/testing with services
├── .env.example             # Environment variable template
├── cloudflare-config.yml    # Example Cloudflare Tunnel config
├── github/
│   └── workflows/
│       └── ci-cd.yml        # GitHub Actions for CI/CD
├── src/
│   └── flow/
│       ├── __init__.py
│       ├── config.py             # Pydantic settings management
│       ├── api/                  # FastAPI service
│       │   ├── __init__.py
│       │   ├── service.py        # API endpoints (/process)
│       │   └── models.py         # Request/Response models
│       ├── graph/                # LangGraph core
│       │   ├── __init__.py
│       │   ├── state.py          # AgentState TypedDict definition
│       │   ├── nodes.py          # Core graph nodes (call_model, call_tool, etc.)
│       │   ├── edges.py          # Conditional edge logic
│       │   └── builder.py        # Graph definition and compilation
│       ├── memory/               # Memory systems (from previous examples)
│       │   ├── __init__.py
│       │   └── ... (working.py, episodic.py, etc.)
│       ├── tools/                # Tool definitions and execution
│       │   ├── __init__.py
│       │   ├── executor.py
│       │   └── definitions/
│       │       ├── __init__.py
│       │       └── ... (payment.py, order_lookup.py, etc.)
│       ├── governance/           # Policy, Audit (from previous examples)
│       │   ├── __init__.py
│       │   └── ...
│       ├── human/                # Human-in-the-Loop (from previous examples)
│       │   ├── __init__.py
│       │   └── ...
│       ├── state_db/             # Persistence for agent state (distinct from memory)
│       │   ├── __init__.py
│       │   └── repository.py     # e.g., MongoDB or Redis backend
│       └── models/               # LLM integrations
│           ├── __init__.py
│           └── llm_provider.py   # Abstraction for different LLMs
├── tests/                    # Unit and integration tests
│   └── ...
└── scripts/                  # Utility scripts (e.g., setup, migrations)
    └── ...
```

**Core Code Scaffolding:**

1.  **`pyproject.toml` (using Poetry):**

    ```toml:pyproject.toml
    [tool.poetry]
    name = \"flow-system\"
    version = \"0.1.0\"
    description = \"Multi-Agent system using LangGraph, FastAPI, and Cloudflare Tunnel\"
    authors = [\"Your Name <you@example.com>\"]

    [tool.poetry.dependencies]
    python = \"^3.9\"
    langchain = \"^0.1.0\"  # Adjust as needed
    langgraph = \"^0.0.30\" # Adjust as needed
    langchain-openai = \"^0.0.5\"
    fastapi = \"^0.104.1\"
    uvicorn = {extras = [\"standard\"], version = \"^0.24.0\"}
    pydantic = \"^2.5.0\"
    pydantic-settings = \"^2.1.0\"
    python-dotenv = \"^1.0.0\"
    # Add memory/tool specific dependencies (e.g., pymongo, redis, requests)
    pymongo = \"^4.6.0\" # Example if using MongoDB for state

    [tool.poetry.dev-dependencies]
    pytest = \"^7.4.3\"
    pytest-asyncio = \"^0.21.1\"
    httpx = \"^0.25.1\" # For testing FastAPI

    [build-system]
    requires = [\"poetry-core>=1.0.0\"]
    build-backend = \"poetry.core.masonry.api\"
    ```

2.  **`src/flow/config.py`:**

    ```python:src/flow/config.py
    from pydantic_settings import BaseSettings
    from typing import List, Optional

    class Settings(BaseSettings):
        APP_NAME: str = \"Flow Multi-Agent System\"
        LOG_LEVEL: str = \"INFO\"

        # API Keys
        OPENAI_API_KEY: str
        # Add other API keys (e.g., for tools)

        # Cloudflare (Optional - for Access validation if needed)
        CF_ACCESS_AUD: Optional[str] = None
        CF_ACCESS_TEAM_DOMAIN: Optional[str] = None

        # State Persistence (Example: MongoDB)
        STATE_DB_URI: str = \"mongodb://localhost:27017/\"
        STATE_DB_NAME: str = \"agent_states\"

        # LangGraph / Model Config
        LLM_MODEL_NAME: str = \"gpt-4-turbo-preview\"
        LLM_TEMPERATURE: float = 0.0

        # Add other configs for memory, tools, etc.

        class Config:
            env_file = '.env'

    settings = Settings()
    ```

3.  **`src/flow/api/models.py`:**

    ```python:src/flow/api/models.py
    from pydantic import BaseModel
    from typing import Optional, Dict, Any, List

    class ProcessRequest(BaseModel):
        user_id: str
        conversation_id: Optional[str] = None
        message: str
        metadata: Optional[Dict[str, Any]] = None # Optional extra data from GPT Action

    class ProcessResponse(BaseModel):
        conversation_id: str
        response: str # The final text response for the user
        state_snapshot: Optional[Dict[str, Any]] = None # Optional: useful for debugging
    ```

4.  **`src/flow/graph/state.py`:**

    ```python:src/flow/graph/state.py
    from typing import TypedDict, List, Dict, Optional, Any
    from langchain_core.messages import BaseMessage

    # Reusing the OrderState from previous examples if applicable, or define new ones
    # from flow.state.schema import OrderState # Import your specific state schemas

    class AgentState(TypedDict):
        \"\"\"Represents the state of our graph.\"\"\"
        messages: List[BaseMessage] # Use LangChain message types
        conversation_id: str
        user_id: str
        working_memory: Dict[str, Any] # Quick access context
        # Add specific state fields needed by your agents/tools
        # order_details: Optional[OrderState]
        tool_calls: Optional[List[Dict[str, Any]]] # Store pending/completed tool calls
        error: Optional[str] # Store errors during execution
    ```

5.  **`src/flow/graph/nodes.py` (Simplified Example):**

    ```python:src/flow/graph/nodes.py
    from langchain_core.messages import HumanMessage, AIMessage, ToolMessage
    from langchain_openai import ChatOpenAI
    from flow.graph.state import AgentState
    from flow.tools.executor import execute_tool # Assume you have this
    from flow.config import settings
    import json

    # Initialize LLM (could be done in builder and passed in)
    llm = ChatOpenAI(model=settings.LLM_MODEL_NAME, temperature=settings.LLM_TEMPERATURE)

    async def call_model(state: AgentState):
        \"\"\"Invokes the LLM to decide the next action or generate a response.\"\"\"
        print(\"--- Calling Model ---\")
        response = await llm.ainvoke(state['messages'])
        # Add the response to the list of messages
        state['messages'].append(response)

        # Check if the model wants to call a tool
        if response.tool_calls:
            print(f\"--- Tool Call Requested: {response.tool_calls} ---\")
            state['tool_calls'] = response.tool_calls
        else:
            state['tool_calls'] = None # Explicitly clear if no tool call

        return state

    async def call_tool(state: AgentState):
        \"\"\"Executes tools based on the LLM's request.\"\"\"
        if not state.get('tool_calls'):
            print(\"--- No Tool Called ---\")
            return state # Skip if no tool calls

        print(\"--- Calling Tool ---\")
        tool_call = state['tool_calls'][0] # Example: handle one tool call at a time
        tool_name = tool_call['name']
        tool_args = tool_call['args']

        # Execute the tool (you'll need your ToolExecutor logic here)
        # This should handle routing to your specific custom GPTs/functions/APIs
        try:
            # result = await tool_executor.execute(tool_name, tool_args, state) # Pass state if needed
            # Simulate tool execution based on your \"tunnel\" concept
            print(f\"Simulating execution of tool '{tool_name}' with args: {tool_args}\")
            # Replace with actual call to your tunnel/backend logic
            # result = your_tunnel_client.call(tool_name, tool_args)
            result = {\"status\": \"success\", \"data\": f\"Result of {tool_name}\"} # Placeholder result

            tool_message = ToolMessage(
                content=json.dumps(result),
                tool_call_id=tool_call['id']
            )
        except Exception as e:
            print(f\"--- Tool Error: {e} ---\")
            tool_message = ToolMessage(
                content=json.dumps({\"error\": str(e)}),
                tool_call_id=tool_call['id']
            )

        state['messages'].append(tool_message)
        state['tool_calls'] = None # Clear after execution
        return state

    # Add other nodes: memory retrieval/update, state persistence, approval checks etc.
    ```

6.  **`src/flow/graph/edges.py`:**

    ```python:src/flow/graph/edges.py
    from flow.graph.state import AgentState

    def route_action(state: AgentState):
        \"\"\"Determines the next step after the model call.\"\"\"
        print(\"--- Routing Action ---\")
        if state.get('tool_calls'):
            print(\"--- Routing to Tool ---\")
            return \"call_tool\"
        else:
            print(\"--- Routing to End ---\")
            return \"__end__\" # End the graph execution if no tool call
    ```

7.  **`src/flow/graph/builder.py`:**

    ```python:src/flow/graph/builder.py
    from langgraph.graph import StateGraph, END
    from flow.graph.state import AgentState
    from flow.graph.nodes import call_model, call_tool # Import other nodes as needed
    from flow.graph.edges import route_action

    def create_graph():
        \"\"\"Builds the LangGraph state machine.\"\"\"
        graph = StateGraph(AgentState)

        # Define nodes
        graph.add_node(\"call_model\", call_model)
        graph.add_node(\"call_tool\", call_tool)
        # Add other nodes for memory, state persistence, etc.

        # Set entry point
        graph.set_entry_point(\"call_model\")

        # Define edges
        graph.add_conditional_edges(
            \"call_model\",
            route_action,
            {
                \"call_tool\": \"call_tool\",
                END: END # Use \"__end__\" for clarity if preferred
            }
        )
        # After a tool is called, loop back to the model to process the result
        graph.add_edge(\"call_tool\", \"call_model\")

        # Compile the graph
        app_graph = graph.compile()
        print(\"--- Graph Compiled ---\")
        return app_graph

    # Singleton instance of the compiled graph
    agent_graph = create_graph()
    ```

8.  **`src/flow/api/service.py` (Main API Endpoint):**

    ```python:src/flow/api/service.py
    from fastapi import FastAPI, HTTPException, Depends, Request
    from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
    from flow.api.models import ProcessRequest, ProcessResponse
    from flow.graph.builder import agent_graph
    from flow.graph.state import AgentState
    from flow.config import settings
    from langchain_core.messages import HumanMessage
    import uuid
    import logging

    # Setup logging
    logging.basicConfig(level=settings.LOG_LEVEL.upper())
    logger = logging.getLogger(__name__)

    app = FastAPI(title=settings.APP_NAME)

    # Optional: Add Cloudflare Access Token Validation
    # This requires configuring Cloudflare Access and your JWT validator
    # auth_scheme = HTTPBearer()
    # async def verify_token(credentials: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    #     token = credentials.credentials
    #     # Add your JWT validation logic here using settings.CF_ACCESS_AUD etc.
    #     # Example: decoded = jwt.decode(token, ...)
    #     # if not valid: raise HTTPException(status_code=401, detail=\"Invalid token\")
    #     # return decoded_payload # e.g., {\"email\": \"user@example.com\"}
    #     logger.info(\"Skipping token validation in dev\") # Placeholder
    #     return {\"email\": \"dev_user@example.com\"} # Placeholder

    @app.post(\"/process\", response_model=ProcessResponse)
    async def process_message(
        request: ProcessRequest,
        # token_payload: dict = Depends(verify_token) # Uncomment for auth
    ):
        \"\"\"
        Receives a message from the tunnel (called by ChatGPT Action),
        runs it through the LangGraph agent, and returns the response.
        \"\"\"
        logger.info(f\"Received request for user {request.user_id}, conversation {request.conversation_id}\")

        conversation_id = request.conversation_id or str(uuid.uuid4())

        # TODO: Load existing state from DB if conversation_id exists
        # state_repo = StateRepository(...)
        # existing_state = await state_repo.load_state(conversation_id)
        # if existing_state: initial_state = existing_state else: ...
        initial_state = AgentState(
            messages=[HumanMessage(content=request.message)],
            conversation_id=conversation_id,
            user_id=request.user_id,
            working_memory={}, # Load initial context if available
            tool_calls=None,
            error=None
        )

        try:
            # Invoke the LangGraph application
            # Use .astream() for streaming back to API if needed
            final_state = await agent_graph.ainvoke(initial_state, {\"recursion_limit\": 10})

            # TODO: Save final state to DB
            # await state_repo.save_state(conversation_id, final_state)

            # Extract the last AIMessage as the response
            ai_response = \"No response generated.\"
            if final_state and final_state.get('messages'):
                for msg in reversed(final_state['messages']):
                    if msg.type == 'ai' and not msg.tool_calls: # Ensure it's a final response, not a tool request
                        ai_response = msg.content
                        break

            logger.info(f\"Generated response for conversation {conversation_id}\")
            return ProcessResponse(
                conversation_id=conversation_id,
                response=ai_response,
                # state_snapshot=final_state # For debugging
            )

        except Exception as e:
            logger.error(f\"Error processing request for {conversation_id}: {e}\", exc_info=True)
            # TODO: Save error state to DB
            raise HTTPException(status_code=500, detail=f\"Internal server error: {e}\")

    @app.get(\"/health\")
    async def health():
        return {\"status\": \"ok\"}
    ```

**GitHub & Cloudflare Integration Points:**

1.  **GitHub Repository:** Store this entire structure in a GitHub repo.
2.  **GitHub Actions (`.github/workflows/ci-cd.yml`):**
    *   Set up workflows to run `pytest` on push/pull request.
    *   Linting (e.g., using `ruff` or `flake8`).
    *   Build Docker image on merge to `main`.
    *   Deploy the Docker image to your hosting environment (e.g., Cloud Run, ECS, Kubernetes).
3.  **Cloudflare Tunnel:**
    *   Install `cloudflared` on your server or use the dashboard.
    *   Create a tunnel: `cloudflared tunnel create flow-tunnel`.
    *   Update `cloudflare-config.yml` (or use dashboard DNS) to point the tunnel hostname (e.g., `flow-agent.yourdomain.com`) to your local FastAPI service (e.g., `http://localhost:8000`).
    *   Run the tunnel: `cloudflared tunnel run flow-tunnel`.
4.  **Cloudflare Access (Optional but Recommended):**
    *   Create an Access Application for your tunnel hostname.
    *   Define policies (e.g., require specific email domains, identity providers, or service tokens).
    *   Configure the application to pass identity via JWTs (set `CF_ACCESS_AUD` and `CF_ACCESS_TEAM_DOMAIN` in `.env`).
    *   Implement JWT validation in your FastAPI service (using the `verify_token` dependency example).
5.  **ChatGPT Action Schema:**
    *   In your Custom GPT settings, define an Action.
    *   Provide an OpenAPI schema that points to your Cloudflare tunnel URL (e.g., `https://flow-agent.yourdomain.com`) and defines the `/process` endpoint with `ProcessRequest` as the body and `ProcessResponse` as the response.
    *   Configure authentication (e.g., \"API Key\" if using a simple header, or \"OAuth\" if integrating with Cloudflare Access user logins).

This scaffolding provides a robust starting point. You'll need to fill in the specific logic for your tools, memory interactions, state transitions, and potentially more complex routing within the LangGraph `edges.py`. Remember to replace placeholder comments and logic with your actual implementations."""),
            ],
        ),
        types.Content(
            role="user",
            parts=[
                types.Part.from_text(text="""INSERT_INPUT_HERE"""),
            ],
        ),
    ]
    generate_content_config = types.GenerateContentConfig(
        response_mime_type="text/plain",
    )

    for chunk in client.models.generate_content_stream(
        model=model,
        contents=contents,
        config=generate_content_config,
    ):
        print(chunk.text, end="")

if __name__ == "__main__":
    generate()
