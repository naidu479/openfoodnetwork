var latitude = "";
var longitude = "";
var phone = "";
var email = "";

getLocation();

function getLocation() {
alert("1");
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
  alert(response);
  var OneSignal = window.OneSignal || [];
  OneSignal.push(["init", {
    appId: "c68e1e56-6658-4fa0-8296-284ace80a4e6",
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
