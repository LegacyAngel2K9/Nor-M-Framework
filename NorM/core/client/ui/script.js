document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("menu").classList.add("hidden");
});

// Listen for NUI Messages
window.addEventListener("message", function (event) {
    if (event.data.action === "openMenu") {
        if (!document.getElementById("menu").classList.contains("hidden")) {
            return; // Prevent opening twice
        }
        document.getElementById("menu").classList.remove("hidden");
    } else if (event.data.action === "closeMenu") {
        document.getElementById("menu").classList.add("hidden");
    }
});

// Function to Handle Menu Selections
function selectOption(option) {
    fetch("https://norm/selectOption", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ option: option })
    }).then(() => closeMenu());
}

// Function to Close Menu
function closeMenu() {
    fetch("https://norm/closeMenu", { method: "POST" });
    document.getElementById("menu").classList.add("hidden");
}
