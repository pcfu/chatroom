import consumer from "./consumer"

consumer.subscriptions.create({ channel: "ChatChannel", room: "main_room"}, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    this.appendLine(data.user, data.message)
    // Called when there's incoming data on the websocket for this channel
  },

  appendLine(user, msg) {
    const html = this.createLine(user, msg);
    document.querySelector('#messages').insertAdjacentHTML('beforeend', html);
  },

  createLine(user, msg) {
    return `
      <div class="chat-line">
        <span class="speaker">User#${user}</span> :
        <span class="line-message">${msg}</span>
      </div>
    `;
  }
});
