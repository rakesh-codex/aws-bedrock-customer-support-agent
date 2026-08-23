# AWS Bedrock Customer Support Agent

An AI-powered customer support agent built with **Python, Amazon Bedrock, and Amazon Bedrock AgentCore**.

The agent combines a foundation model with purpose-built tools and managed agent capabilities to handle common customer-support scenarios. It can answer product-related questions, retrieve return-policy information, assist with troubleshooting, and maintain relevant customer context using **Amazon Bedrock AgentCore Memory**.

The project demonstrates a practical approach to building, testing, and deploying a **tool-enabled, context-aware AI agent on AWS** using a code-based Python architecture.

## 🚀 Overview

This project implements a customer-support AI agent capable of:

* Answering product-related questions
* Retrieving and explaining return policies
* Assisting customers with troubleshooting
* Using external web information when additional context is required
* Selecting the appropriate tool based on the user's request
* Maintaining relevant customer context with AgentCore Memory
* Supporting context across customer interactions
* Running locally during development
* Deploying the agent to Amazon Bedrock AgentCore Runtime
* Invoking the deployed agent through the AgentCore CLI

The architecture follows an **agent + tools + memory** approach rather than implementing all business logic directly inside the application.

## 🏗️ Architecture

```text
                         ┌──────────────────────┐
                         │      User / Client   │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │   Customer Support   │
                         │        Agent         │
                         │       (Python)       │
                         └──────────┬───────────┘
                                    │
                ┌───────────────────┼───────────────────┐
                │                   │                   │
                ▼                   ▼                   ▼
       ┌────────────────┐  ┌────────────────┐  ┌────────────────┐
       │ Product Lookup │  │ Return Policy  │  │  Web Search    │
       └────────────────┘  └────────────────┘  └────────────────┘
                │                   │                   │
                └───────────────────┼───────────────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │   Amazon Bedrock     │
                         │   Foundation Model   │
                         └──────────┬───────────┘
                                    │
                         ┌──────────▼───────────┐
                         │  AgentCore Memory    │
                         │                      │
                         │ • Conversation       │
                         │ • Customer Context   │
                         │ • Preferences        │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │ AgentCore Runtime    │
                         │      AWS Cloud       │
                         └──────────────────────┘
```

## ✨ Key Capabilities

### Product Support

The agent can understand customer questions about products and provide relevant information using the available product-support tools.

Example:

```text
User:
What is the warranty period for this product?

Agent:
The product is covered by the standard warranty policy...
```

### Return Policy

The agent can retrieve return-policy information and explain the applicable policy to customers in natural language.

Example:

```text
User:
Can I return my product after 20 days?

Agent:
According to the current return policy...
```

### Troubleshooting

When the available product information is not sufficient, the agent can use web-search capabilities to find relevant troubleshooting information.

Example:

```text
User:
My device keeps disconnecting from Wi-Fi. How can I fix it?

Agent:
I'll look for troubleshooting information related to this issue...
```

### 🧠 AgentCore Memory

The agent uses **Amazon Bedrock AgentCore Memory** to maintain relevant context beyond an individual request.

This allows the customer-support agent to move from a stateless question-and-answer experience toward a more **context-aware and personalized support experience**.

Memory can be used to:

* Maintain context during customer interactions
* Retrieve relevant information from previous interactions
* Preserve useful customer preferences and context
* Provide more personalized responses
* Support continuity across sessions
* Separate conversational memory from the agent's core business logic

The memory capability is managed through **Amazon Bedrock AgentCore**, avoiding the need to build and maintain a custom persistence layer for agent memory.

### Memory Flow

```text
Customer Request
       │
       ▼
Customer Support Agent
       │
       ▼
Retrieve Relevant Memory
       │
       ▼
Understand Current Request
       │
       ├───────────────┬────────────────┐
       ▼               ▼                ▼
 Product Tool    Return Policy     Web Search
       │               │                │
       └───────────────┴────────────────┘
                       │
                       ▼
                Generate Response
                       │
                       ▼
              Store Relevant Context
                       │
                       ▼
                AgentCore Memory
```

## 🧠 Agent Design

The application follows a **tool-enabled agent architecture**.

Instead of implementing a large number of conditional statements such as:

```text
if question == product:
    ...
elif question == return_policy:
    ...
elif question == troubleshooting:
    ...
```

the agent uses the foundation model to understand the user's intent and determine which capability should be used.

AgentCore Memory extends this architecture by allowing the agent to retrieve and persist relevant customer context.

This makes the architecture easier to extend with additional tools, memory strategies, and business capabilities.

## ☁️ AWS Services

The project uses the following AWS technologies:

| Service                      | Purpose                                      |
| ---------------------------- | -------------------------------------------- |
| **Amazon Bedrock**           | Foundation model for the AI agent            |
| **Amazon Bedrock AgentCore** | Agent runtime and managed agent capabilities |
| **AgentCore Memory**         | Persistent agent and customer context        |
| **AWS IAM**                  | Authentication and authorization             |
| **AWS Cloud infrastructure** | Hosting and runtime execution                |

The AgentCore CLI provides commands for creating projects, running agents locally, deploying them to AWS, checking status, and invoking deployed agents.

## 🛠️ Technology Stack

* **Python**
* **Amazon Bedrock**
* **Amazon Bedrock AgentCore**
* **AgentCore Memory**
* **Strands Agents**
* **AWS SDK / Boto3**
* **AWS IAM**
* **AgentCore CLI**

## 📁 Project Structure

```text
aws-bedrock-customer-support-agent/
│
├── agentcore/
│   ├── agentcore.json
│   └── aws-targets.json
│
├── app/
│   └── CustomerSupport/
│       ├── main.py
│       └── pyproject.toml
│
├── .gitignore
├── README.md
└── ...
```

The AgentCore project structure separates agent configuration from the Python application code and AWS deployment targets.

## ⚙️ Prerequisites

Before running the project, make sure you have:

* Python 3.10+
* Node.js 20+
* npm
* AWS CLI
* An AWS account
* AWS credentials configured locally
* Required IAM permissions
* Access to the selected Amazon Bedrock foundation model

## 🔐 AWS Configuration

Configure your AWS credentials using the AWS CLI:

```bash
aws configure
```

Verify that the credentials are available:

```bash
aws sts get-caller-identity
```

Make sure the AWS identity being used has the permissions required to access Amazon Bedrock and deploy resources through AgentCore.

## 📦 Install AgentCore CLI

Install the AgentCore CLI:

```bash
npm install -g @aws/agentcore
```

Verify the installation:

```bash
agentcore --help
```

## ▶️ Run Locally

Navigate to the project directory:

```bash
cd aws-bedrock-customer-support-agent
```

Start the local development environment:

```bash
agentcore dev
```

This starts the local AgentCore development environment and allows the agent to be tested before deploying it to AWS.

## 🚀 Deploy to AWS

Deploy the agent to Amazon Bedrock AgentCore Runtime:

```bash
agentcore deploy
```

The deployment process packages the application and provisions the required AWS infrastructure for the AgentCore Runtime.

## 🔎 Check Deployment Status

After deployment:

```bash
agentcore status
```

This can be used to inspect the deployed AgentCore resources.

## 💬 Invoke the Agent

Invoke the deployed agent:

```bash
agentcore invoke "What is the return policy?"
```

You can also invoke a specific runtime:

```bash
agentcore invoke --runtime CustomerSupport "How can I troubleshoot my device?"
```

## 📊 Observability

For troubleshooting and operational visibility, AgentCore provides runtime logs and traces that can be inspected through the AWS environment and AgentCore tooling.

Useful commands include:

```bash
agentcore logs
```

and:

```bash
agentcore traces
```

This provides a foundation for investigating agent behavior, tool execution, memory interactions, and runtime issues.

## 🔄 Agent Execution Flow

A typical request follows this flow:

```text
1. User submits a question
           │
           ▼
2. Agent receives the request
           │
           ▼
3. Retrieve relevant memory
           │
           ▼
4. Foundation model understands intent
           │
           ▼
5. Agent determines required capability
           │
           ├───────────────┬────────────────┐
           │               │                │
           ▼               ▼                ▼
     Product Tool    Return Policy     Web Search
           │               │                │
           └───────────────┴────────────────┘
                           │
                           ▼
6. Tool result returned
           │
           ▼
7. Foundation model generates response
           │
           ▼
8. Relevant context is persisted
           │
           ▼
9. Customer receives response
```

## 🎯 Engineering Goals

This project focuses on demonstrating the following engineering concepts:

* Building tool-enabled AI agents
* Integrating foundation models with application logic
* Using Amazon Bedrock for generative AI
* Implementing managed agent memory
* Building context-aware AI experiences
* Deploying Python agents to AWS
* Separating agent reasoning from business capabilities
* Designing extensible tool interfaces
* Running agents locally before cloud deployment
* Using managed AWS infrastructure for agent runtime execution
* Designing AI applications that can evolve toward production workloads

## 📈 Project Evolution

The project is being developed incrementally toward a production-oriented AI agent architecture.

```text
Customer Support Agent
        │
        ▼
Amazon Bedrock Integration
        │
        ▼
AgentCore Runtime
        │
        ▼
AgentCore Memory
        │
        ▼
Context-Aware Support Agent
        │
        ▼
Tool-Enabled AI Assistant
        │
        ▼
Production-Oriented Agent Architecture
```

## 🔮 Future Enhancements

Potential extensions include:

* Product catalog integration
* Customer authentication
* Order-status lookup
* CRM integration
* Knowledge-base / RAG integration
* Human-agent escalation
* Structured tool responses
* Agent evaluation and automated testing
* CloudWatch-based monitoring
* Agent identity and authorization
* Additional enterprise support tools
* Multi-agent orchestration

## 👨‍💻 Author

**Rakesh Bhandarkar**

Senior .NET / AI Engineer | Technical Lead

GitHub: [@rakesh-codex](https://github.com/rakesh-codex)

---

## 📚 References

* [Amazon Bedrock AgentCore Documentation](https://docs.aws.amazon.com/bedrock-agentcore/)
* [AgentCore Runtime Documentation](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-get-started-cli.html)
* [AgentCore Memory Documentation](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/memory-get-started.html)
* [AWS AgentCore CLI](https://github.com/aws/agentcore-cli)

---

⭐ If you find this project useful, consider giving the repository a star.
