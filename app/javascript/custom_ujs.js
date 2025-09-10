document.addEventListener('turbolinks:load', function() {
    // Select all links with data-ujs attribute
    const unassignLinks = document.querySelectorAll('a[data-ujs="true"]');
  
    unassignLinks.forEach(link => {
      link.addEventListener('click', function(event) {
        // Prevent default action
        event.preventDefault();
  
        // Show confirmation dialog
        const confirmed = confirm(link.dataset.confirm);
  
        // If confirmed, create and submit a form
        if (confirmed) {
          const method = link.dataset.method || 'get'; // Default to GET if not specified
          const url = link.href;
  
          // Create a new form to submit the request
          const form = document.createElement('form');
          form.method = method;
          form.action = url;
  
          // Append the form to the body and submit
          document.body.appendChild(form);
          form.submit();
        }

        console.log('Custom UJS script loaded');

      });
    });
  });


