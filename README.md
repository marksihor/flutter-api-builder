<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
import 'package:api_builder/models/endpoint.dart';
import 'package:api_builder/models/field.dart';
import 'package:api_builder/models/form.dart';
import 'package:api_builder/models/option.dart';
import 'package:api_builder/presentations/components/form_builder.dart';
import 'package:api_builder/presentations/fields/select_field.dart';
import 'package:api_builder/presentations/styles/form_style.dart';
import 'package:flutter/material.dart';

class ExampleFormPage extends StatelessWidget {
  const ExampleFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example Form Page')),
      body: FromBuilder(
        form: Form_(
          endpoint: Endpoint(
            method: FormSubmitMethod.post,
            path: 'api/public/auth/login',
          ),
          getFieldErrors: (form, field) {
            // Each api can return validation errors differently, so you need to
            // return the list of errors that responds to current field or return
            // an empty list if the field has no errors.
            // Below is example of handling errors from Laravel project response

            var fieldErrors = form.error!.data['errors'][field.path];
            return fieldErrors is List
                ? fieldErrors.map((e) => e.toString()).toList()
                : [];
          },
          onSubmitError: (Form_ form) {
            // handle submit error, do redirect, show modal, etc...
          },
          onSubmitSuccess: (Form_ form) async {
            // handle submit success, do redirect, show modal, etc...
          },
          fields: loadSubfieldOptionsBasedOnParentFieldValueExample(),
          submitButton: ElevatedButton(
            onPressed: () {},
            child: const Text('Submit'),
          ),
          style: FormStyle(
            elementsPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
          ),
        ),
      ),
    );
  }

  List<Field> loadSubfieldOptionsBasedOnParentFieldValueExample() {
    return [
      Field(
        label: 'Make (can be loaded from api)',
        hint: 'Select Make',
        path: 'make_id',
        builder: (f) => SelectField(field: f),
        getOptions: (_) async {
          return [
            Option(label: 'BMW', value: 1),
            Option(label: 'Audi', value: 2),
          ];
        },
        subfields: [
          Field(
            label: 'Model (depends on Make, can be loaded from api)',
            hint: 'Select Model',
            path: 'model_id',
            builder: (f) => SelectField(field: f),
            getOptions: (Field? parent) async {
              if (parent?.value?.value == 1) {
                return [
                  Option(label: '3 series', value: '3series'),
                  Option(label: '5 series', value: '5series'),
                ];
              } else if (parent?.value?.value == 2) {
                return [
                  Option(label: 'A4', value: 'a4'),
                  Option(label: 'A6', value: 'a6'),
                ];
              }
              return [];
            },
          ),
        ],
      ),
    ];
  }
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
