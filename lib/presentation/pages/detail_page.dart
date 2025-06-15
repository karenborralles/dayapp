import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import '../../../domain/entities/history_event.dart';

class DetailPage extends StatefulWidget {
  final String year;
  final List<HistoryEvent> events;

  const DetailPage({super.key, required this.year, required this.events});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late FlutterTts flutterTts;
  final translator = GoogleTranslator();
  List<HistoryEvent> translatedEvents = [];
  bool isTranslating = true;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setLanguage('es-ES');
    flutterTts.setSpeechRate(0.4);
    traducirEventos();
  }

  Future<void> traducirEventos() async {
    final List<HistoryEvent> nuevos = [];
    for (var e in widget.events.where((e) => e.year == widget.year)) {
      final traduccion = await translator.translate(e.text, from: 'en', to: 'es');
      nuevos.add(HistoryEvent(year: e.year, text: traduccion.text));
    }
    setState(() {
      translatedEvents = nuevos;
      isTranslating = false;
    });
  }

  Future<void> leerEventos() async {
    for (var e in translatedEvents) {
      await flutterTts.speak(e.text);
      await flutterTts.awaitSpeakCompletion(true);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isTranslating
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: Colors.teal,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Año ${widget.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/history.jpg',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black45, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      flutterTts.stop();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${translatedEvents.length} evento(s) encontrado(s)',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: leerEventos,
                          icon: const Icon(Icons.volume_up, color: Colors.teal),
                        )
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: translatedEvents.length,
                    (context, index) {
                      final event = translatedEvents[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.arrow_right, size: 28, color: Colors.teal),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        event.text,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}