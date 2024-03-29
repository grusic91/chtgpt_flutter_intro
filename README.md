# Flutter ChatGPT API Interaction

This Flutter application demonstrates how to interact with OpenAI's ChatGPT API. Users can send messages, and the app will display responses from ChatGPT.

## Features

- Send messages to ChatGPT and receive responses.
- User-friendly interface with text input and a send button.
- Displays ChatGPT's responses in the app.
- Generate images using DALL-E's image generation API.

## Getting Started

To run this app, you need to have Flutter installed on your machine. For more information on how to install Flutter, visit [Flutter's official documentation](https://flutter.dev/docs/get-started/install).

### Prerequisites

- Flutter SDK
- Dart SDK
- An IDE (e.g., Android Studio, VS Code, IntelliJ)
- OpenAI acconunt and secret key

### Installation

1. Clone the repository to your local machine
2. Navigate to the project directory
3. Install dependencies


### Configuration

Before running the app, you need to set up your OpenAI API key:

1. Obtain an API key from OpenAI by creating an account at [OpenAI's Platform](https://platform.openai.com/).
2. Store your API key in a secure location.
3. In the `secrets.dart` file, replace the placeholder token with your actual OpenAI API key.

### Running the App

1. Ensure an emulator or physical device is connected.
2. Run the app

## Usage

- Enter a message in the text field.
- Press the send button to submit the message to ChatGPT.
- View ChatGPT's response in the app interface.
- To generate an image, type "generate image" followed by your prompt (e.g., "generate image a cute cat").

## Models

The app uses two main model classes:

### ChatCompletionResponse

- Parses the JSON response from the ChatGPT API.
- Contains fields like `id`, `object`, `created`, `model`, and `choices`.

### ImageGenerationResult

- Parses the JSON response from the DALL-E API.
- Contains fields like `created` and `data`.

## Libraries

- `http`: For making API requests.
- `json_annotation`: For JSON serialization.
- `dash_chat_2`: For the chat UI interface.

## Acknowledgments
- OpenAI for providing the ChatGPT API.
