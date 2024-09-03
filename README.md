
# EffectiveMobileTodoList App

Welcome to the EffectiveMobileTodoList App! This iOS application is designed to help you manage your daily tasks effortlessly. With a simple and user-friendly interface, staying organized has never been easier.

# Features:
- Task Overview: View all your tasks conveniently on the main screen.
- Add Tasks: Easily add new tasks to keep track of everything you need to do.
- Edit Tasks: Make quick edits to existing tasks to keep your list up to date.
- Delete Tasks: Remove tasks that you've completed or no longer need.

#
### BDD Specs

## Todo List Feed Feature Specs

### Story: Customer requests to see the todo list feed

### Narrative #1

```
As an online customer
I want the app to automatically load the latest todo list feed
So I can always monitor my todo list in the app
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to see the todo list feed
 Then the app should display the latest feed from remote
  And cache the new feed
```

### Narrative #2

```
As an offline customer
I want the app to show the latest saved version of todo list feed
So I can always check my todo list
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
  And there’s a cached version of the feed
 When the customer requests to see the feed
 Then the app should display the latest feed saved
 
Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the feed
 Then the app should display an error message
```

## Use Cases

### Load Feed From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Tasks Feed" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates tasks feed from valid data.
5. System delivers tasks feed.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

## Model Specs

###Source

| Property      | Type                      |
|---------------|---------------------------|
| 'id'          | 'String' (optional)       |
| ‘name’        | 'String'                  |

###Article

| Property      | Type                      |
|---------------|---------------------------|
| 'source'      | 'Source'                  |
| ‘author’      | 'String' (optional)       |
| 'title'       | 'String'                  |
| 'description' | 'String' (optional)       |
| ‘url’         | 'URL'                     |
| 'urlToImage'  | 'URL' (optional)          |
| 'publishedAt' | 'Date'                    |
| 'content'     | 'String' (optional)       |

### Load Feed From Cache Use Case

#### Primary course:
1. Execute "Load Tasks Feed" command with above data.
2. System retrieves feed data from cache.
4. System creates tasks feed from cached data.
5. System delivers image feed.

#### Retrieval error course (sad path):
1. System delivers error.

#### Expired cache course (sad path): 
1. System delivers no feed articles.

#### Empty cache course (sad path): 
1. System delivers no feed articles.

---

# Load Tasks Feed FlowChart
![EffectiveMobileTodoList](https://github.com/Fenominall/EffectiveMobileTodoList/blob/main/TasksLoadFlowChart.png)

### Cache Feed Use Case

#### Data:
- Task

#### Primary course (happy path):
1. Execute "Save Tasks" command with above data.
3. System encodes articles feed.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.
---
