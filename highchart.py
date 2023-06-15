import streamlit as st
import requests
from highcharts import Highchart
import openai


# Set up OpenAI
open.api_key = "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"

# Set up the Streamlit app
st.title("Interactive Data Visualization with Highcharts.js and OpenAI, and Postman")

# Define the Swagger API endpoint for the data
swagger_endpoint = "https://swagger.quantifycrypto.com"

# Fetch the Swagger specification and extract the relevent information
swagger_spec = requests.get(swagger_endpoint).json()
data_endpoint = swagger_spec['paths']['/data']['post']['x-swagger-endpoint']

# Create an input section for the user to enter prompts
prompt = st.text_input("Enter your data query prompt:")

# Define a function to get data based on  the user's promt
def get_data_from_api(prompt):
    # Make a POST request to the data endpoint with the prompt
    response = requests.post(data_endpoint, json={'prompt': prompt})
    data = response.json()
    return data

# Get data and redraw the chart when the user submits the prompt
if st.button("Get Data"):
    if prompt:
        # Get data from the API using OpenAI and the user's prompt
        api_data = get_data_from_api(prompt)

    # Process the data and extract relevant information for charting
    x_values = api_data['x']
    y_values = api_data['y']

    # Visualize the data using Highcharts.js
    chart = Highchart()
    chart.set_options({
        'chart': {'type': 'line'},
        'title': {'text': 'Data Visualization'},
        'xAxis': {'categories': x_values},
        'yAxis': {'title': {'text': 'Values'}},
        'series': [{'name': 'Data', 'data': y_values}],
    })

    # Render the chart in Streamlit
    st.write(chart)

else:l
    st.error("Please enter a prompt.")

    # Add a section for testing the API using Postman
    st.subheader("API Testing with Postman")

    # Create input fields for HTTP method and request body
    http_method = st.selectbox("HTTP Method", ["POST", "GET"])
    request_body = st.text_area("Request Body")

    # Send the API request and display the response
    if st.button("Send API Request"):
        if http_method and request_body:
            if http_method == "POST":
                response = requests.post(data_endpoint, json=request_body)
            elif http_method == "GET":
                response = requests.get(data_endpoint, params=request_body)

            st.write("Response: ")
            st.json(response.json())

        else:
            st.error("Please select an HTTP method and enter a request body.")



