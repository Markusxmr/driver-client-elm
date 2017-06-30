var Elm = require("../elm/Main");
var root = document.getElementById("main");
var app = Elm.Main.embed(root, localStorage.session || null);

app.ports.storeSession.subscribe(function(session) {
  localStorage.session = session;
});

app.ports.deleteDialog.subscribe(function(msg) {
  var cnfrm = confirm("Izbrisati?");
  if (cnfrm) {
    app.ports.deleteConfirmation.send(msg);
  } else {
    console.log("Otkazano");
  }
});

app.ports.upload.subscribe(function(msg) {
  var url = `http://localhost:4000/admin_api/question_image/${msg.id}`;
  var fileInput = document.getElementById(msg.element);
  var session = JSON.parse(localStorage.session);
  var oReq = new XMLHttpRequest();

  var formData = new FormData();
  formData.append("files", fileInput.files[0]);

  oReq.open("post", url, true);
  oReq.setRequestHeader("Authorization", "Token " + session.token);

  oReq.onload = function(e) {
    if (oReq.readyState == 4) {
      if (oReq.status == 200) {
        console.log(oReq.responseText);
        app.ports.reqListener.send("refetch");
      } else {
        console.error(oReq.statusText);
      }
    }
  };

  oReq.send(formData);
});

window.addEventListener(
  "storage",
  function(event) {
    if (event.storageArea === localStorage && event.key === "session") {
      app.ports.onSessionChange.send(event.newValue);
    }
  },
  false
);
