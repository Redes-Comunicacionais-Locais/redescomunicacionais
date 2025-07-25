import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'markdown_styles.dart';

class MarkdownEditor extends StatefulWidget {
  final TextEditingController? controller;

  const MarkdownEditor({super.key, this.controller});

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  void applyFormatting(String startTag, [String? endTag]) {
    endTag ??= startTag;

    final text = _controller.text;
    final selection = _controller.selection;

    final selectedText = selection.textInside(text);
    final newText = startTag + selectedText + endTag;

    final updatedText = text.replaceRange(selection.start, selection.end, newText);

    _controller.value = TextEditingValue(
      text: updatedText,
      selection: TextSelection.collapsed(offset: selection.start + newText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botões de formatação
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                tooltip: 'Negrito',
                icon: const Icon(Icons.format_bold),
                onPressed: () => applyFormatting('**'),
              ),
              IconButton(
                tooltip: 'Itálico',
                icon: const Icon(Icons.format_italic),
                onPressed: () => applyFormatting('_'),
              ),
              IconButton(
                tooltip: 'Citação',
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () => applyFormatting('> ', ''),
              ),
              IconButton(
                tooltip: 'Lista',
                icon: const Icon(Icons.format_list_bulleted),
                onPressed: () => applyFormatting('- ', ''),
              ),
              IconButton(
                tooltip: 'Código',
                icon: const Icon(Icons.code),
                onPressed: () => applyFormatting('`'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Campo de texto
        TextField(
          controller: _controller,
          maxLines: 6,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Corpo da Notícia",
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Preview Markdown
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              return MarkdownBody(
                data: value.text.isEmpty
                    ? 'Texto em **Markdown** aparecerá aqui...'
                    : value.text,
                styleSheet: customMarkdownStyle
              );
            },
          ),
        ),
      ],
    );
  }
}
