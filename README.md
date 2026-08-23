# AWS Bedrock Customer Support Agent

An enterprise-oriented AI customer support platform built with **Python, Amazon Bedrock, and Amazon Bedrock AgentCore**.

The project demonstrates how to build, deploy, secure, evaluate, and continuously improve an AI agent using AWS managed agent capabilities.

The customer support agent combines **foundation model reasoning, tools, persistent memory, MCP-based integrations, authorization policies, safety guardrails, evaluation, managed orchestration, frontend interaction, and controlled A/B experimentation**.

The goal is to demonstrate a complete **agent engineering lifecycle**, from local development through production-oriented deployment, governance, evaluation, and optimization.

---

## 🚀 Overview

The customer support agent can:

* Answer product-related questions
* Retrieve and explain return policies
* Assist with troubleshooting
* Invoke tools based on user intent
* Access external capabilities through AgentCore Gateway
* Discover and invoke MCP tools
* Maintain relevant customer context using AgentCore Memory
* Run inside Amazon Bedrock AgentCore Runtime
* Apply policy-based authorization to tool access
* Apply Bedrock Guardrails for safety and sensitive information protection
* Evaluate agent quality and behavior
* Run through a user-facing frontend
* Use AgentCore Harness for managed agent orchestration
* Generate optimization recommendations
* Run controlled A/B experiments
* Compare agent variants using online evaluations and statistical significance

The architecture follows an:

**Agent + Tools + Memory + Gateway + Governance + Evaluation + Optimization**

model.

---

# 🏗️ High-Level Architecture

```text
                              ┌──────────────────────┐
                              │       Customer       │
                              │     Web Frontend     │
                              └──────────┬───────────┘
                                         │
                                         ▼
                              ┌──────────────────────┐
                              │  Customer Support    │
                              │       Agent          │
                              │       Python         │
                              └──────────┬───────────┘
                                         │
                     ┌───────────────────┼───────────────────┐
                     │                   │                   │
                     ▼                   ▼                   ▼
              Product Tools       Return Policy       Gateway / MCP
                                                           │
                                                           ▼
                                                  ┌──────────────────┐
                                                  │ AgentCore        │
                                                  │ Gateway          │
                                                  └────────┬─────────┘
                                                           │
                                      ┌────────────────────┼────────────────────┐
                                      │                    │                    │
                                      ▼                    ▼                    ▼
                                  MCP Tools              APIs              External
                                                                            Services
                                                          
                                         │
                                         ▼
                              ┌──────────────────────┐
                              │   Amazon Bedrock     │
                              │   Foundation Model   │
                              └──────────┬───────────┘
                                         │
                              ┌──────────▼───────────┐
                              │   AgentCore Memory   │
                              │                      │
                              │ • Session Context   │
                              │ • Customer Context  │
                              │ • Preferences       │
                              └──────────┬───────────┘
                                         │
                                         ▼
                              ┌──────────────────────┐
                              │ AgentCore Runtime    │
                              │      AWS Cloud       │
                              └──────────┬───────────┘
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    │                    │
                    ▼                    ▼                    ▼
             AgentCore Policy      Guardrails          Observability
                    │                    │                    │
                    └────────────────────┼────────────────────┘
                                         │
                                         ▼
                              ┌──────────────────────┐
                              │ AgentCore Evaluations│
                              └──────────┬───────────┘
                                         │
                                         ▼
                              ┌──────────────────────┐
                              │ AgentCore            │
                              │ Optimization         │
                              └──────────┬───────────┘
                                         │
                                         ▼
                                  A/B Experiments
```

---

# ✨ Core Capabilities

## 1. Customer Support Agent

The core agent uses a foundation model to understand customer intent and determine which capability should be used to answer a request.

Example:

```text
User:
Can I return my product after 20 days?

Agent:
I'll check the applicable return policy...
```

The agent can reason about the request rather than relying on a large collection of hard-coded conditional statements.

---

# 🔧 Tool-Enabled Agent

The agent can use purpose-built capabilities for different customer-support scenarios.

### Product Support

Answers product-related questions using the available product-support capabilities.

### Return Policy

Retrieves and explains applicable return-policy information.

### Troubleshooting

Uses available tools and external information to help customers troubleshoot problems.

The architecture keeps business capabilities separate from the agent's reasoning layer, making additional tools easier to introduce.

---

# 🧠 AgentCore Memory

The agent uses **Amazon Bedrock AgentCore Memory** to maintain relevant customer context across interactions.

This allows the system to move from a stateless chatbot toward a **context-aware customer-support assistant**.

Memory can be used for:

* Conversation context
* Previous customer interactions
* Customer preferences
* Long-term contextual information
* Personalized responses
* Cross-session continuity

### Memory Flow

```text
Customer Request
       │
       ▼
Retrieve Relevant Memory
       │
       ▼
Agent Reasoning
       │
       ▼
Tool Execution
       │
       ▼
Generate Response
       │
       ▼
Persist Relevant Context
       │
       ▼
AgentCore Memory
```

---

# 🔌 AgentCore Gateway

**Amazon Bedrock AgentCore Gateway** provides a centralized connectivity layer between the agent and external tools.

Instead of coupling the agent directly to every external integration, capabilities can be exposed through Gateway.

Gateway supports MCP-based tool discovery and invocation and provides a common interface for accessing external capabilities.

```text
                     Customer Support Agent
                              │
                              │ MCP
                              ▼
                    ┌────────────────────┐
                    │  AgentCore Gateway │
                    └─────────┬──────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼
          MCP Tools          APIs          Services
```

This architecture provides:

* Centralized tool connectivity
* Tool discovery
* MCP-based integration
* Separation between agent logic and external systems
* A foundation for centralized authorization
* Easier addition of new integrations

---

# 🔐 AgentCore Policy

The project uses **AgentCore Policy** to provide fine-grained authorization around agent and tool interactions.

Policies can determine:

* Who can access a tool
* Which action can be performed
* Which Gateway resource can be accessed
* Under which conditions an operation is allowed

Policy enforcement provides a deterministic authorization layer outside the agent's reasoning.

```text
Agent
  │
  ▼
AgentCore Gateway
  │
  ▼
Policy Evaluation
  │
  ├── ALLOW
  │
  └── DENY
  │
  ▼
Tool Execution
```

AgentCore Gateway policies use Cedar-based authorization to govern tool calls and access conditions.

---

# 🛡️ Bedrock Guardrails

The project also integrates **Amazon Bedrock Guardrails** with the policy layer to add safety controls around agent interactions.

Guardrails can evaluate requests and responses for areas such as:

* Prompt injection
* Jailbreak attempts
* Harmful content
* Sensitive information
* Credentials and secrets
* Other configured safety categories

This creates a layered security architecture:

```text
User Request
     │
     ▼
Agent
     │
     ▼
Gateway
     │
     ▼
Policy + Guardrails
     │
     ├── Allowed
     │
     └── Denied
     │
     ▼
Tool / External System
```

AWS documents Guardrails integration with AgentCore Policy for prompt attacks, content filtering, and sensitive information detection.

---

# 🚀 AgentCore Runtime

The agent is deployed to **Amazon Bedrock AgentCore Runtime** for managed cloud execution.

The runtime provides the production execution environment for the agent without requiring the application to manage its own agent hosting infrastructure.

Typical deployment flow:

```bash
agentcore deploy
```

Check deployment:

```bash
agentcore status
```

Invoke the deployed agent:

```bash
agentcore invoke "What is the return policy?"
```

---

# 📊 AgentCore Evaluations

The project uses **Amazon Bedrock AgentCore Evaluations** to measure agent performance.

Evaluation can be used to assess:

* Helpfulness
* Correctness
* Task completion
* Tool behavior
* Agent consistency
* Custom business metrics

AgentCore Evaluations supports online, on-demand, batch, dataset, and simulation-oriented evaluation workflows.

### Evaluation Loop

```text
Agent Execution
      │
      ▼
Telemetry / Traces
      │
      ▼
AgentCore Evaluations
      │
      ▼
Quality Metrics
      │
      ▼
Identify Weaknesses
      │
      ▼
Optimization
```

---

# 🧩 AgentCore Harness

The project also explores **AgentCore Harness** as a managed orchestration environment for agent execution.

The Harness capability brings together agent execution capabilities such as:

* Model configuration
* Tools
* Memory
* Environment
* Filesystem
* Observability
* Versioning
* Evaluation
* Optimization

The managed Harness is powered by Strands Agents and provides a higher-level approach to running and operating production-oriented agents.

Conceptually:

```text
                 AgentCore Harness
                        │
       ┌────────────────┼────────────────┐
       │                │                │
       ▼                ▼                ▼
     Model            Tools           Memory
       │                │                │
       └────────────────┼────────────────┘
                        │
                        ▼
                  Agent Execution
                        │
       ┌────────────────┼────────────────┐
       │                │                │
       ▼                ▼                ▼
 Observability      Evaluation      Optimization
```

---

# 🎨 Customer Frontend

A user-facing frontend provides an interface for interacting with the deployed customer-support agent.

The frontend provides the application layer between the customer and the AgentCore-based backend.

```text
Customer
   │
   ▼
Frontend
   │
   ▼
Agent Runtime
   │
   ├── Memory
   ├── Tools
   ├── Gateway
   └── Policies
   │
   ▼
Response
```

This separates the presentation layer from the agent and AWS infrastructure layers.

---

# 📈 Agent Optimization

The project implements an agent optimization workflow using **AgentCore Optimization**.

Instead of manually changing prompts and assuming the new version is better, the optimization workflow uses real agent traces and evaluation results to identify opportunities for improvement.

AgentCore Optimization provides capabilities including recommendations, configuration bundles, and controlled A/B testing.

### Continuous Improvement Loop

```text
             Agent Traffic
                   │
                   ▼
              Agent Traces
                   │
                   ▼
             Evaluations
                   │
                   ▼
           Optimization Insights
                   │
                   ▼
          Configuration Change
                   │
                   ▼
              A/B Testing
                   │
          ┌────────┴────────┐
          ▼                 ▼
       Control          Treatment
          │                 │
          └────────┬────────┘
                   ▼
          Statistical Results
                   │
                   ▼
             Winning Variant
                   │
                   ▼
             New Baseline
                   │
                   └──────► Repeat
```

---

# 🧪 A/B Testing

The project also includes AgentCore A/B testing capabilities.

A/B testing allows two agent variants to receive controlled traffic so their performance can be compared using online evaluations.

Possible variants include:

* Different system prompts
* Different model configurations
* Different tool descriptions
* Different agent implementations
* Different configuration bundle versions

AgentCore Gateway handles traffic routing while online evaluations score sessions and the service calculates statistical significance.

### A/B Test Flow

```text
                    Incoming Traffic
                           │
                           ▼
                  AgentCore Gateway
                           │
                 ┌─────────┴─────────┐
                 │                   │
                 ▼                   ▼
             CONTROL             TREATMENT
              Agent                 Agent
                 │                   │
                 └─────────┬─────────┘
                           ▼
                   Online Evaluation
                           │
                           ▼
                  Statistical Analysis
                           │
                           ▼
                    Compare Results
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
        Keep Control             Promote Treatment
```

AWS's A/B testing workflow uses Gateway traffic splitting and online evaluations to compare variants and determine whether observed differences are statistically significant.

---

# 🔄 Complete Agent Lifecycle

The project demonstrates the following end-to-end lifecycle:

```text
1. Build
   │
   ▼
2. Local Development
   │
   ▼
3. Bedrock Integration
   │
   ▼
4. AgentCore Runtime
   │
   ▼
5. Memory
   │
   ▼
6. Gateway + MCP Tools
   │
   ▼
7. Policy + Guardrails
   │
   ▼
8. Deployment
   │
   ▼
9. Frontend
   │
   ▼
10. Evaluations
    │
    ▼
11. Harness
    │
    ▼
12. Optimization
    │
    ▼
13. A/B Testing
    │
    ▼
14. Promote Winning Configuration
    │
    └──────────────► Continuous Improvement
```

---

# 🏛️ Production-Oriented Architecture

The overall architecture can be viewed as several independent layers:

```text
┌─────────────────────────────────────────────────────┐
│                    PRESENTATION                     │
│                                                     │
│                 Customer Frontend                   │
└──────────────────────────┬──────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────┐
│                     AGENT                           │
│                                                     │
│          Python / Strands / Bedrock                 │
└──────────────────────────┬──────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────┐
│                  CAPABILITIES                       │
│                                                     │
│        Tools / Memory / Gateway / MCP               │
└──────────────────────────┬──────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────┐
│                 GOVERNANCE                          │
│                                                     │
│       IAM / AgentCore Policy / Guardrails            │
└──────────────────────────┬──────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────┐
│                  RUNTIME                            │
│                                                     │
│              AgentCore Runtime                     │
└──────────────────────────┬──────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────┐
│              QUALITY & OPERATIONS                   │
│                                                     │
│ Evaluations / Observability / Harness / Optimization│
└─────────────────────────────────────────────────────┘
```

---

# ☁️ AWS Services & Capabilities

| AWS Capability                | Purpose                                   |
| ----------------------------- | ----------------------------------------- |
| **Amazon Bedrock**            | Foundation model access                   |
| **AgentCore Runtime**         | Managed agent execution                   |
| **AgentCore Memory**          | Persistent contextual memory              |
| **AgentCore Gateway**         | External tool and MCP connectivity        |
| **AgentCore Policy**          | Fine-grained authorization                |
| **Amazon Bedrock Guardrails** | Safety and sensitive-information controls |
| **AgentCore Evaluations**     | Agent quality measurement                 |
| **AgentCore Harness**         | Managed agent orchestration               |
| **AgentCore Optimization**    | Data-driven agent improvement             |
| **AgentCore A/B Testing**     | Controlled variant experimentation        |
| **AWS IAM**                   | Identity and access management            |
| **CloudWatch / telemetry**    | Runtime observability                     |

---

# 🛠️ Technology Stack

### AI / Agent

* Python
* Amazon Bedrock
* Strands Agents
* Amazon Bedrock AgentCore
* Model Context Protocol (MCP)

### AgentCore Capabilities

* AgentCore Runtime
* AgentCore Memory
* AgentCore Gateway
* AgentCore Policy
* AgentCore Harness
* AgentCore Evaluations
* AgentCore Optimization
* AgentCore A/B Testing

### Security

* AWS IAM
* Cedar-based authorization policies
* Amazon Bedrock Guardrails

### Infrastructure / Operations

* AWS Cloud infrastructure
* CloudWatch
* AgentCore CLI
* OpenTelemetry-based observability

---

# 📁 Project Structure

The exact structure may evolve as additional AgentCore capabilities are added.

```text
aws-bedrock-customer-support-agent/
│
├── agentcore/
│   ├── agentcore.json
│   ├── aws-targets.json
│   └── ...
│
├── app/
│   └── CustomerSupport/
│       ├── main.py
│       ├── pyproject.toml
│       └── ...
│
├── frontend/
│   └── ...
│
├── .gitignore
├── LICENSE
└── README.md
```

The repository separates application code, AgentCore configuration, frontend components, and deployment-related resources.

---

# ⚙️ Prerequisites

Before running the project, make sure you have:

* Python 3.10+
* Node.js
* npm
* AWS CLI
* AWS account
* AWS credentials configured
* Required IAM permissions
* Access to the selected Amazon Bedrock foundation model
* AgentCore CLI

---

# 🔐 AWS Configuration

Configure AWS credentials:

```bash
aws configure
```

Verify the active identity:

```bash
aws sts get-caller-identity
```

The AWS identity must have the required permissions for Amazon Bedrock and the AgentCore resources used by the project.

**Never commit AWS credentials, access keys, secret keys, tokens, or `.env` files to the repository.**

---

# 📦 AgentCore CLI

Install the AgentCore CLI according to the current AWS documentation.

Verify:

```bash
agentcore --help
```

Common development commands include:

```bash
agentcore dev
agentcore deploy
agentcore status
agentcore invoke
```

---

# ▶️ Local Development

Navigate to the project:

```bash
cd aws-bedrock-customer-support-agent
```

Run the local agent:

```bash
agentcore dev
```

This allows the agent to be tested locally before deployment.

---

# 🚀 Deployment

Deploy the agent and configured AgentCore resources:

```bash
agentcore deploy
```

Check deployment:

```bash
agentcore status
```

Invoke the deployed agent:

```bash
agentcore invoke "What is the return policy?"
```

---

# 📊 Observability

Observability is an important part of the architecture because evaluation and optimization depend on high-quality agent telemetry.

The project uses AgentCore/AWS observability capabilities to inspect:

* Agent execution
* Tool calls
* Runtime behavior
* Gateway interactions
* Memory interactions
* Evaluation data
* Optimization signals

AgentCore Optimization uses traces and evaluation results as inputs for its continuous improvement workflow.

---

# 🔒 Security Model

Security is implemented in multiple layers:

```text
                    User
                      │
                      ▼
                  Frontend
                      │
                      ▼
                    Agent
                      │
                      ▼
               AgentCore Gateway
                      │
              ┌───────┴────────┐
              ▼                ▼
           Policy          Guardrails
              │                │
              └───────┬────────┘
                      ▼
                Tool / API
                      │
                      ▼
               External System
```

### Security principles

* Least-privilege IAM
* Gateway-level authorization
* Cedar policy enforcement
* Prompt attack detection
* Sensitive information detection
* Content filtering
* Separation of agent reasoning from authorization decisions
* No credentials committed to source control

---

# 🎯 Engineering Objectives

This project demonstrates practical experience with:

* Generative AI application development
* Agentic AI architecture
* Foundation model integration
* Tool-enabled agents
* MCP-based tool integration
* Persistent agent memory
* Managed cloud agent runtime
* Fine-grained authorization
* AI safety controls
* Agent evaluation
* Observability
* Agent orchestration
* Configuration management
* A/B experimentation
* Statistical evaluation
* Continuous agent optimization
* Production-oriented AI engineering

---

# 📈 What This Project Demonstrates

Rather than treating an AI agent as simply:

```text
Prompt → LLM → Response
```

the project treats the agent as a complete software system:

```text
                ┌───────────────┐
                │     User      │
                └───────┬───────┘
                        │
                        ▼
                ┌───────────────┐
                │    Frontend   │
                └───────┬───────┘
                        │
                        ▼
                ┌───────────────┐
                │     Agent     │
                └───────┬───────┘
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
       Memory        Gateway         Tools
          │             │             │
          └─────────────┼─────────────┘
                        ▼
                    Governance
                  ┌─────┴─────┐
                  ▼           ▼
               Policy     Guardrails
                  │           │
                  └─────┬─────┘
                        ▼
                     Runtime
                        │
                        ▼
                  Observability
                        │
                        ▼
                   Evaluations
                        │
                        ▼
                  Optimization
                        │
                        ▼
                    A/B Test
                        │
                        ▼
                  Winning Agent
```

This provides a foundation for building AI systems that are not only capable of answering questions, but can also be **secured, measured, monitored, evaluated, and continuously improved**.

---

# 🔮 Future Enhancements

Potential future extensions include:

* Enterprise knowledge-base / RAG integration
* Production CRM integration
* Order-management integration
* Customer identity integration
* Additional MCP servers
* Advanced memory strategies
* Human-agent escalation
* Custom evaluation datasets
* Automated regression testing
* CI/CD integration
* Infrastructure as Code
* Multi-agent orchestration
* Cost optimization
* Advanced security policies
* Production traffic management
* Automated promotion and rollback workflows

---

# 👨‍💻 Author

**Rakesh Bhandarkar**

Senior .NET / AI Engineer | Technical Lead

GitHub: [@rakesh-codex](https://github.com/rakesh-codex)

---

# 📚 References

* [Amazon Bedrock AgentCore](https://docs.aws.amazon.com/bedrock-agentcore/)
* [AgentCore Runtime](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-get-started-cli.html)
* [AgentCore Memory](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/memory-get-started.html)
* [AgentCore Gateway](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html)
* [AgentCore Policy](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/policy.html)
* [AgentCore Guardrails](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/policy-guardrails-in-policies.html)
* [AgentCore Evaluations](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/evaluations.html)
* [AgentCore Harness](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/harness.html)
* [AgentCore Optimization](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/optimization.html)
* [AgentCore A/B Testing](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/ab-testing.html)

---

⭐ If you find this project useful, consider giving the repository a star.
