import 'package:flutter/material.dart';

import '../../data/models/field.dart';
import '../../data/models/option.dart';
import 'field_mixin.dart';

class TagsField extends StatefulWidget with FieldMixin {
  @override
  final Field field;

  TagsField({super.key, required this.field});

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  final TextEditingController _controller = TextEditingController();

  final List<Option> selected = [];

  @override
  void initState() {
    if (widget.field.value is List) {
      for (var e in widget.field.value) {
        selected.add(Option(label: e.toString(), value: e.toString()));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.field.hint,
            enabled: !widget.field.readonly,
          ),
          onChanged: (value) {
            if (value.toString().endsWith(' ')) {
              _controller.text = '';
              String tag = value.trim();
              if (tag.length > 1) {
                var option = Option(label: tag, value: tag);
                if (!selected.contains(option)) {
                  setState(() {
                    selected.add(option);
                  });

                  widget.setFieldValue(context, selected);
                }
              }
            }
            // widget.setFieldValue(context, value);
          },
          readOnly: widget.field.readonly,
        ),
        Wrap(
          children: selected.map((e) => _buildTag(context, e)).toList(),
        )
      ],
    );
  }

  Widget _buildTag(BuildContext context, Option option) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected.removeWhere((e) => e.value == option.value);
          });

          widget.setFieldValue(context, selected);
        },
        child: Chip(
          // labelPadding: EdgeInsets.zero,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(option.label.toUpperCase()),
              const Icon(Icons.clear, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
