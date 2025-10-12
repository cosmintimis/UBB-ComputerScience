
## Life After School
Lectures, seminars and labs ... school in general must be taken seriously; BUT so must be your social life and leisure time. To manage the latter and be always informed about the interesting events happening in your city you will implement a software application. The application can be used in two modes: administrator and user. When the application is started, it will offer the option to choose the mode.\
**Administrator mode:** The application will have a database which holds all the interesting events in your area. You must be able to update the database, meaning: add a new event, delete an event and update the information of an event. Each **Event** has a `title`, a `description`, a `date and time`, a `number of people` who are going and a `link` towards the online resource containing the event. The administrators will also have the option to see all the events in the database.\
**User mode:** A user can create a list with the events that he/she is interested in. The application will allow the user to:
- See the events in the database for a given month (if there is no month given, see all the events, ordered chronologically), one by one. When the user chooses this option, the data of the first event (title, description, date and time, number of people who are going) is displayed, and the event is opened in the browser (e.g. Facebook event).
- If the user wants to participate in the event he/she can choose to add it to his/her events list. When this happens, the number of people who are going to the event increases (for the event in the repository).
- If the event seems uninteresting, the user can choose not to add it to the list and continue to the next. In this case, the information corresponding to the next event is shown, and the user is again offered the possibility to add it to his/her list. This can continue as long as the user wants, as when arriving to the end of the list of events for the given month, if the user chooses next, the application will again show the first event.
- Delete an event from the list. When the user deletes an event from his/her list, the number of people who are going to the event decreases.
- See the list of events the user wants to attend.

# Assignment 08-09

## Requirements
- Create a graphical user interface using the Qt framework for the problem you have been working on (A04-05, A06, A07).

## Week 11
- Implement the interface design, without using the Qt Designer. Use layouts to design your interface.
- The list or table displaying the repository entities in administrator mode should be populated using your input file. 

## Week 13 
-	All functionalities must be available through the GUI. You may use Qt Designer, if you want to change the initial design of your GUI.
-	The functionality of the application must be the same (including the one-by-one iteration of objects for the user mode).

## Bonus possibility (0.2p, deadline week 13)
Create a graphical representation of the data in your application. You have an example below: a bar chart representing the number of songs for each artist. Your representations can be a bar chart, a pie chart or another type of chart. You can even use circles or rectangles or any other geometric shapes to represent the data.

Hint: You can use QPainter (https://doc.qt.io/qt-6/qpainter.html), QGraphicsScene (https://doc.qt.io/qt-6/qgraphicsscene.html) or a special widget designed for plotting and data visualisation – QCustomPlot (http://www.qcustomplot.com/).

<img width="704" alt="Screenshot 2021-04-17 at 20 24 04" src="https://user-images.githubusercontent.com/25611695/115121335-df0f7e00-9fba-11eb-8839-40cd55da1d69.png">

