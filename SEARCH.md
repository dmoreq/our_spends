# Search Functionality

## 1. Overview

This document outlines the search functionality integrated into the AI Chat interface of Our Spends. By leveraging natural language processing (NLP), the application offers a powerful and intuitive way to find, analyze, and manage expenses without a traditional search screen.

## 2. Guiding Principles

- **Simplicity**: Eliminate complex search forms in favor of a conversational interface.
- **Power**: Enable complex queries through natural language.
- **Intelligence**: Provide contextual insights, not just data.
- **Accessibility**: Support multiple languages to cater to a diverse user base.

## 3. How It Works

The search functionality is powered by an AI model that interprets user queries from the chat interface. The AI parses the natural language input to identify intent and parameters, which are then translated into a structured query for the `ExpenseQueryService`.

### Key Features

- **Natural Language Queries**: Ask for your data in plain English or Vietnamese.
- **Contextual Awareness**: The AI remembers the context of your conversation for follow-up questions.
- **Summaries and Insights**: Get aggregated data and summaries directly in the chat.
- **Multi-Parameter Search**: Combine criteria like date, category, amount, and tags in a single query.

### Supported Search Parameters

- **Date Range**: "from last week," "in February," "between May 1 and May 15"
- **Category**: "groceries," "transportation," "dining"
- **Amount**: "over $50," "less than $10," "around $20"
- **Payment Method**: "paid with cash," "on my credit card"
- **Tags**: "tagged as 'work'," "with the 'vacation' tag"
- **Keywords**: "coffee," "lunch," "taxi"

## 4. Example Conversations

### Example 1: Simple Search and Refinement

**User**: "Show me my expenses from yesterday."
**AI**: "Yesterday, you had 3 expenses totaling $45.50:
- Coffee: $5.00
- Lunch at Cafe Luna: $15.50
- Taxi Ride: $25.00"

**User**: "How much did I spend on food?"
**AI**: "You spent $20.50 on food yesterday (Coffee and Lunch)."

### Example 2: Complex Search

**User**: "Find all transportation expenses over $20 from last month tagged as 'work'."
**AI**: "I found two transportation expenses matching your criteria from last month:
- Taxi to Airport: $45.00 (March 15)
- Client Meeting Ride: $28.00 (March 22)"

## 5. Technical Implementation

The AI-powered search is built on the following components:

- **AI Chat Interface**: Captures user input and displays results.
- **AI Service**: Processes natural language queries to extract intent and entities (e.g., dates, categories).
- **`ExpenseQueryService`**: Constructs and executes database queries based on the structured data received from the AI Service.
- **`DatabaseService`**: Interacts with the SQLite database to fetch expense records.

The flow is as follows:
1. User types a query in the chat.
2. The AI Service processes the text.
3. The service returns a structured query object.
4. `ExpenseQueryService` uses this object to fetch data from the database.
5. The results are formatted and returned to the user in a conversational response.

## 6. Future Enhancements

- **Saved Searches**: Allow users to save frequent search queries.
- **Proactive Alerts**: Notify users of unusual spending patterns based on their search history.
- **Voice-Activated Search**: Integrate voice commands for hands-free searching.