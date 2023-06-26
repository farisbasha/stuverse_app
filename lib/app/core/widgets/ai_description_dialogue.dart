import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stuverse_app/app/core/widgets/svg_asset_image.dart';
import 'package:stuverse_app/utils/app_images.dart';

import '../cubit/ai_desc/ai_desc_cubit.dart';

class AIDescriptionDialogue extends StatefulWidget {
  const AIDescriptionDialogue({
    super.key,
    required this.descriptionController,
    required this.title,
  });
  final TextEditingController descriptionController;
  final String title;

  @override
  State<AIDescriptionDialogue> createState() => _AIDescriptionDialogueState();
}

class _AIDescriptionDialogueState extends State<AIDescriptionDialogue> {
  late ConfettiController _confettiController;
  final _aiDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiDescCubit, AiDescState>(
      listener: (context, state) {
        if (state is AiDescLoaded) {
          _aiDescriptionController.text = state.description;
          _confettiController.play();
        }

        if (state is AiDescError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: IgnorePointer(
            ignoring: state is AiDescLoading,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Introducing AI",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Description Generator",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      SvgAssetImage(
                        assetName: AppImages.ai,
                        color: Theme.of(context).colorScheme.primary,
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      //Instructions
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enter a description of your product in simple words and let our AI generate a description for you.",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ConfettiWidget(
                        confettiController: _confettiController,
                        numberOfParticles: 20,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const <Color>[
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.red,
                          Colors.indigo,
                          Colors.orange,
                          Colors.purple
                        ],
                        createParticlePath: drawStar,
                        canvas: Size.infinite,
                        child: TextFormField(
                          controller: _aiDescriptionController,
                          validator: (value) {
                            if (value!.length < 10) {
                              return 'Should have minimum 10 char';
                            }
                            if (value.length > 100) {
                              return 'Should have maximum 100 char';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            labelText: 'AI Description',
                            hintText:
                                'Eg: [For a bag]\nNike bag, lime color, 2 month old, good condition',
                          ),
                          maxLines: 5,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (state is AiDescLoading)
                        LoadingAnimationWidget.beat(
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AiDescCubit>().generateDesc(
                                        description:
                                            _aiDescriptionController.text,
                                        title: widget.title);
                                  }
                                },
                                icon: Icon(FontAwesomeIcons.wandMagicSparkles,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: 15),
                                label: Text(
                                  "Generate",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                widget.descriptionController.text =
                                    _aiDescriptionController.text;
                                _confettiController.stop();
                                Navigator.pop(context);
                              },
                              icon: Icon(FontAwesomeIcons.download,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  size: 15),
                              label: Text(
                                "Use this",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Function to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const int numberOfPoints = 5;
    final double halfWidth = size.width / 2;
    final double externalRadius = halfWidth;
    final double internalRadius = halfWidth / 2.5;
    final double degreesPerStep = degToRad(360 / numberOfPoints);
    final double halfDegreesPerStep = degreesPerStep / 2;
    final Path path = Path();
    final double fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
