document.addEventListener("DOMContentLoaded", function () {
  let uislider = document.getElementById("uislider");
  let min = document.getElementById("min-slider");
  let max = document.getElementById("max-slider");
  
  noUiSlider.create(uislider, {
    start: [10, 99],
    connect: true,
    range: {
      min: 10,
      max: 99,
      },
  });
  
  uislider.noUiSlider.on("update", function (values) {
    min.textContent = "$" + values[0];
    max.textContent = "$" + values[1];
  });
  
  uislider.noUiSlider.on("update", filterDishes);
});