FROM frappe/erpnext:v15.35.0

USER frappe

# Copy the Marley Healthcare app
COPY --chown=frappe:frappe ./marley_healthcare_app /home/frappe/frappe-bench/apps/marley_healthcare_app

# Install the app
WORKDIR /home/frappe/frappe-bench
RUN bench get-app --skip-assets marley_healthcare_app && \
    bench build --apps marley_healthcare_app

# Switch back to the bench directory
WORKDIR /home/frappe/frappe-bench

USER frappe
