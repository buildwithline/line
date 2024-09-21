function copyToClipboard(text) {
  if (navigator.clipboard && window.isSecureContext) {
    // Use the modern Clipboard API
    navigator.clipboard
      .writeText(text)
      .then(() => alert("Link copied to clipboard!"))
      .catch((err) => console.error("Could not copy text to clipboard:", err));
  } else {
    // Fallback for older browsers
    const textArea = document.createElement("textarea");
    textArea.value = text;
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();

    try {
      const successful = document.execCommand("copy");
      const msg = successful ? "successful" : "unsuccessful";
      console.log("Fallback: Copying text command was " + msg);
      if (successful) alert("Link copied to clipboard!");
    } catch (err) {
      console.error("Fallback: Oops, unable to copy", err);
    }

    document.body.removeChild(textArea);
  }
}

document.addEventListener("turbo:load", function () {
  const copyButtons = document.querySelectorAll(".copy-button");
  copyButtons.forEach((button) => {
    button.addEventListener("click", function () {
      const textToCopy = this.dataset.copyText;
      copyToClipboard(textToCopy);
    });
  });
});
