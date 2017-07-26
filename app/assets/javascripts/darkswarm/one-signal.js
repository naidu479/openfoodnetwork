var latitude = "";
var longitude = "";
var phone = "";
var email = "";

getLocation();

function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  } else {
    alert("Geolocation is not supported by this browser.");
  }
}

function getEmail() {
  this.email = prompt("Please enter your Email Id", "email@xyz.com");
}

function getPhone() {
  this.phone = prompt("Please enter your Phone Number", "xxx-xxx-xxxx");
}


function showPosition(position) {
  this.latitude = position.coords.latitude;
  this.longitude = position.coords.longitude;
}

function fetchIP(callback) {
  window.setTimeout(function() {
    $.get("https://ipinfo.io", function(response) {
      callback(response);
    }, "jsonp");
  }, 2000);
}

function sendData(response) {
  var OneSignal = window.OneSignal || [];
  OneSignal.push(["init", {
    appId: "f2a1468e-a993-448f-8656-5903c7325c3b",
    autoRegister: false,
    notifyButton: {
      enable: true /* Set to false to hide */
    },

    welcomeNotification: {
      "title": "My CUSTOM Title",
      "message": "Thanks for subscribing! Enter CUSTOM message here.",
    }
  }]);

  OneSignal.push(function() {
    OneSignal.setDefaultTitle("My CUSTOM Title");
    OneSignal.showHttpPrompt();
    OneSignal.sendTags({
      IP: response.ip,
      Country: response.country,
      Latitude: this.latitude,
      Longitude: this.longitude,
      Email: this.email,
      Phone: this.phone
    });
  });
}

fetchIP(sendData);
