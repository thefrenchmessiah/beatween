import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static values = { chatroomId: Number }
  static targets = ["messages", "newMessage"]

  // connect() {
  //   console.log(this.chatroomIdValue)
  //   this.channel = createConsumer().subscriptions.create(
  //     { channel: "ChatroomChannel", chatroom_id: this.chatroomIdValue },
  //     { received: data => {
  //       console.log('received callback called') 
  //       console.log("hello")
  //       console.log(data);
  //       this.#insertMessageAndScrollDown(data); 
  //       }
  //     },
  //   )
  // console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}.`)
  // }
  connect() {
  console.log(this.chatroomIdValue);
  this.channel = createConsumer().subscriptions.create(
    { channel: "ChatroomChannel", chatroom_id: this.chatroomIdValue },
    { 
      connected: () => {
        console.log('Successfully connected to the server'); // log when successfully connected to the server
      },
      received: (data) => {
        console.log('received callback called')
        this.#insertMessageAndScrollDown(data) ; 
      }
    },
  )
  console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}.`)
}

  #insertMessageAndScrollDown(data) {
    console.log('insertMessageAndScrollDown called')
    console.log(data)
    console.log(this.messagesTarget)
    this.messagesTarget.insertAdjacentHTML("beforeend", data)
    console.log(this.messagesTarget.scrollHeight)
    window.scrollTo(0, document.body.scrollHeight)
    // this.messagesTarget.scrollTo(0, -200)
  }
  
  resetForm(event) {
    console.log('Form submitted');
    this.newMessageTarget.reset();
  }

  appendMessage(event) {
    const html = event.detail[0].body.innerHTML
    this.messagesTarget.insertAdjacentHTML('beforeend', html)
  }

  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }

}
