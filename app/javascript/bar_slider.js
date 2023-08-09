document.addEventListener("DOMContentLoaded", function () {
  let uislider = document.getElementById("uislider");
  let min = document.getElementById("min-slider");
  let max = document.getElementById("max-slider");

  noUiSlider.create(uislider, {
    start: [10, 70],
    connect: true,
    range: {
      min: 10,
      max: 70,
    },
  });

  uislider.noUiSlider.on("update", function (values) {
    min.textContent = "$" + values[0];
    max.textContent = "$" + values[1];

    filterDishPrice(values);
  });

  function filterDishPrice(values) {
    const dishItems = document.getElementsByClassName("dish-item");
    const minPrice = parseFloat(values[0]);
    const maxPrice = parseFloat(values[1]);
    for (const dishItem of dishItems) {
      const dishPrice = parseFloat(dishItem.dataset.price);
      if (dishPrice <= maxPrice && dishPrice >= minPrice) {
        dishItem.style.display = "inline-block";
      } else {
        dishItem.style.display = "none";
      }
    }
  }
});
