document.addEventListener("turbo:load", function () {
  console.log("Modal script loaded");
});

document.addEventListener("DOMContentLoaded", function () {
  const modal = document.getElementById("loginModal");
  const loginTriggers = document.querySelectorAll(".login-trigger");
  const closeModal = document.querySelector(".close");

  loginTriggers.forEach(button => {
    button.addEventListener("click", function () {
      modal.style.display = "block";
    });
  });

  closeModal.addEventListener("click", function () {
    modal.style.display = "none";
  });

  window.addEventListener("click", function (event) {
    if (event.target === modal) {
      modal.style.display = "none";
    }
  });
});
