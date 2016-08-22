# **Messenger** - *Using Swift*

This application tries to mimic UI of Facebook's chat application called Messenger. This project uses *Core Data* to persist data across reboots. This application  is mainly to demo following things:

* [x] For ease of navigation, the application has iOS's native UI element, UITabbar.
* [x] In the opening screen the user is able to see all the conversations he/she had with his/her friends
* [x] Conversation which has received the most recent message appears at the top, followed by the next most recent message and so on
* [x] In the conversation list, user is able to see profile images of the user. For demonstration purpose, profile images are static
* [x] In the conversation list, user can see the last message in the conversation
* [x] Relative dates, the user can see when the last message was sent for each of the conversations in the list. The date is formatted to show relative date with respect to current date
  * [x] If the last message was received within the last 7 days, first three letters of the week day is displayed
  * [x] If the last message was received yesterday or today, 'Yesterday' or 'Today' is displayed
* [x] In the chat window, user sees all the messages received from his friend to the left hand side of the screen
  * [x] The message appears in bubble
  * [x] Profile image view of the message author is displayed. For demo purpose, this image is currently static
* [x] When the user taps on the text field to type a message, a keyboard appears from bottom.
  * [x] The chat window scrolls up so that the last message of the conversation gets placed right on top of the text field.
* [x] When the user sends a message, the message appears in the chat list
  * [x] The message is persisted using Core Data
  * [x] The chat window is updated with the message that was sent

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/tQ4G6DT.gif' title='Video Walkthrough of FB Messenger' width='' alt='Video Walkthrough of FB Messenger' />
