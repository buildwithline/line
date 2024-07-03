// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "../assets/stylesheets/application.tailwind.css";


document.addEventListener('DOMContentLoaded', () => {
	const alertElement = document.querySelector('.alert');
	if (alertElement) {
			const alertMessage = alertElement.getAttribute('data-alert-message');
			if (alertMessage) {
			alert(alertMessage);
			}
	}
});