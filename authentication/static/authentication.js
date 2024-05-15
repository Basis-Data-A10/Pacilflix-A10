function login() {
    const login = $("#login");
  
    $.ajax({
      type: "POST",
      url: "/login/",
      data: login.serialize(),
    }).done(function (data) {
      login.trigger("reset");
    });
  }
  
  function register() {
    const register = $("#register");
  
    $.ajax({
      type: "POST",
      url: "/register/",
      data: register.serialize(),
    }).done(function (data) {
      register.trigger("reset");
    });
  }