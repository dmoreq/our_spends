# Search Functionality in Our Spends

## Overview

In Our Spends, search functionality is integrated directly into the AI Chat interface, providing a more intuitive and powerful way to find and analyze your expenses. This approach eliminates the need for a separate search screen while enhancing the search capabilities through natural language processing.

## How to Search Using AI Chat

### Basic Search

To search for expenses, simply type your query in the Chat screen. For example:

- "Show me all my coffee expenses"
- "Find expenses from last week"
- "How much did I spend on groceries this month?"

### Advanced Search Parameters

You can refine your search using various parameters:

- **Date Range**: "Show expenses between March 1 and March 15"
- **Category**: "List all transportation expenses"
- **Amount Range**: "Find expenses over $50"
- **Location**: "Show expenses from New York"
- **Payment Method**: "List all expenses paid with my credit card"
- **Tags**: "Show expenses tagged as 'business'"

### Combining Search Parameters

The AI understands complex queries that combine multiple parameters:

- "Show me restaurant expenses over $30 from last month"
- "How much did I spend on groceries and household items in February?"
- "Find all transportation expenses paid with cash in the last two weeks"

## Search Results

The AI will respond with:

1. A list of matching expenses
2. Summary information (total amount, count, etc.)
3. Relevant insights about the search results

## Benefits of AI-Powered Search

- **Natural Language**: No need to learn specific search syntax
- **Contextual Understanding**: The AI understands the intent behind your queries
- **Conversational Flow**: You can refine your search through follow-up questions
- **Insights**: Get analysis along with your search results
- **Multi-Language Support**: Search in English or Vietnamese

## Example Search Conversations

### Example 1: Category Search with Follow-up

**User**: "Show me my dining expenses from last month"

**AI**: "I found 8 dining expenses from last month totaling $245.32. Here they are:
1. Seafood Restaurant - $65.20 (March 5)
2. Coffee Shop - $12.50 (March 7)
..."

**User**: "Which one was the most expensive?"

**AI**: "The most expensive dining expense last month was $65.20 at Seafood Restaurant on March 5."

### Example 2: Complex Query

**User**: "How much did I spend on transportation and food while I was in Chicago?"

**AI**: "Based on your expenses tagged with location 'Chicago', you spent:
- $125.40 on transportation (3 expenses)
- $210.75 on food (5 expenses)
Total: $336.15 across 8 expenses during your time in Chicago."

## Implementation Details

The search functionality is implemented through:

1. Natural language processing in the AI service
2. Integration with the ExpenseQueryService for database queries
3. Context management to maintain conversation state
4. Multi-language support for queries in different languages