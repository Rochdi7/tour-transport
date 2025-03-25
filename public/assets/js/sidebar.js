document.addEventListener("DOMContentLoaded", function () {
    const sidebar = document.querySelector(".sidebar");
    const closeSidebarBtn = document.querySelector(".close-sidebar");
    const dropdownLinks = document.querySelectorAll(".sidebar .dropdown-toggle");

    // Close Sidebar Function
    closeSidebarBtn.addEventListener("click", function () {
        sidebar.classList.remove("active");
        sidebar.style.overflowY = "auto"; // Ensure scrolling is possible
        document.querySelectorAll(".sidebar .collapse").forEach(el => el.classList.remove("show"));
    });

    // Handle Mobile Dropdown Clicks
    dropdownLinks.forEach((dropdown) => {
        dropdown.addEventListener("click", function (event) {
            event.preventDefault();

            let targetMenu = document.querySelector(this.getAttribute("data-target"));

            if (targetMenu.classList.contains("show")) {
                targetMenu.classList.remove("show");
            } else {
                // Close all other dropdowns before opening a new one
                document.querySelectorAll(".sidebar .collapse").forEach(el => el.classList.remove("show"));
                targetMenu.classList.add("show");

                // Ensure dropdown scrolls when it contains many items
                targetMenu.style.maxHeight = "300px";
                targetMenu.style.overflowY = "auto";
            }
        });
    });

    // Close Sidebar and Dropdowns When Clicking Outside
    document.addEventListener("click", function (event) {
        let isClickInsideSidebar = sidebar.contains(event.target) || event.target.closest(".menu-toggle");

        if (!isClickInsideSidebar) {
            sidebar.classList.remove("active");
            sidebar.style.overflowY = "auto";
            document.querySelectorAll(".sidebar .collapse").forEach(el => el.classList.remove("show"));
        }
    });
});
