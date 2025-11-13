# Tokenizer
[![macOS](https://img.shields.io/badge/macOS-26.1+-pink.svg)](https://www.apple.com/macos/) [![App Version](https://img.shields.io/badge/App_Version-1.0-brightgreen.svg)](https://github.com/kerdofficial/Tokenizer)

**A fast, accurate tokenizer built for OpenAI models. Instantly estimate token usage, validate prompt size, and avoid unexpected API costs — all with model-aware encoding.**

---

## Overview  
Tokenizer is a native macOS utility that uses OpenAI’s tokenization logic (via the Tiktoken library) to **reliably count tokens** as they would be processed by OpenAI language models.

---

## Features  
- Instant token-count for any text input.  
- Select encoding based on model: e.g., `o200k_base` for GPT-4o, `cl100k_base` for GPT-4/GPT-3.5, `p50k_base` for older Codex models.  
- Real-time updates as you type or paste text.  
- Clean, native macOS UI built with Swift & SwiftUI.  
- Ideal for API developers, prompt engineers and anyone working with language-model usage.

---

## Contributing  
Contributions are welcome! If you spot a bug, have feature requests or want to improve token-encoding support:  
1. Fork the repository.  
2. Create a feature branch.  
3. Write tests (if applicable).  
4. Submit a pull request with a clear description of your changes.

---

## Acknowledgements 
The original Tiktoken Swift implementation was built by [asepinilla](https://github.com/aespinilla/Tiktoken), and later modified by [me](https://github.com/kerdofficial/Tokenizer). 

## License  
This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
