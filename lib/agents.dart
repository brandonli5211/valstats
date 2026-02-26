import 'package:flutter/material.dart';
import 'package:projects/agent/agent_http_client.dart';
import 'package:projects/color/color.dart';
import 'package:projects/constants/http.dart';
import 'package:projects/drawer.dart';
import 'package:projects/model/agent.dart';

class AgentsPage extends StatefulWidget {
  const AgentsPage({super.key});

  @override
  State<AgentsPage> createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {
  final _httpClient = AgentHttpClient(agentUrl);
  late final Future<List<AgentModel>> _agentsFuture;
  late final PageController _pageController;
  double _currentPageValue = 0;
  bool _expanded = false;
  int? _selectedAbility;

  @override
  void initState() {
    super.initState();
    _agentsFuture = _httpClient.getAgents();
    _pageController = PageController(viewportFraction: 0.78)
      ..addListener(() {
        setState(() {
          _currentPageValue = _pageController.page ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
      if (!_expanded) _selectedAbility = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      extendBodyBehindAppBar: true,
      drawer: const ValDrawer(currentPage: 'agents'),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'agents',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: valRed.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/vallogo.png',
                fit: BoxFit.contain,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<AgentModel>>(
        future: _agentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: valRed),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'no agents found',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }
          final agents = snapshot.data!;
          final currentIndex =
              _currentPageValue.round().clamp(0, agents.length - 1);
          final currentAgent = agents[currentIndex];

          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      currentAgent.parseGradientColor(0),
                      bgBlue,
                    ],
                    stops: const [0.0, 0.65],
                  ),
                ),
              ),
              if (currentAgent.background != null)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Opacity(
                    key: ValueKey(currentAgent.uuid),
                    opacity: 0.06,
                    child: Image.network(
                      currentAgent.background!,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 8),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: agents.length,
                        physics: _expanded
                            ? const NeverScrollableScrollPhysics()
                            : null,
                        onPageChanged: (_) {
                          setState(() {
                            _expanded = false;
                            _selectedAbility = null;
                          });
                        },
                        itemBuilder: (context, index) {
                          final diff = index - _currentPageValue;
                          final scale =
                              (1 - (diff.abs() * 0.08)).clamp(0.88, 1.0);
                          final opacity =
                              (1 - (diff.abs() * 0.6)).clamp(0.2, 1.0);
                          final isActive = index == currentIndex;

                          return Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: _AgentSlide(
                                agent: agents[index],
                                expanded: isActive && _expanded,
                                selectedAbility:
                                    isActive ? _selectedAbility : null,
                                onTap: isActive ? _toggleExpand : null,
                                onAbilityTap: (i) {
                                  setState(() {
                                    _selectedAbility =
                                        _selectedAbility == i ? null : i;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(agents.length, (index) {
                          final isActive = index == currentIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isActive ? 24 : 8,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: isActive ? valRed : Colors.white24,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AgentSlide extends StatelessWidget {
  final AgentModel agent;
  final bool expanded;
  final int? selectedAbility;
  final VoidCallback? onTap;
  final ValueChanged<int> onAbilityTap;

  const _AgentSlide({
    required this.agent,
    required this.expanded,
    this.selectedAbility,
    this.onTap,
    required this.onAbilityTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = expanded
            ? constraints.maxHeight * 0.65
            : constraints.maxHeight * 0.42;
        final portraitBottom =
            expanded ? cardHeight * 0.12 : cardHeight * 0.30;

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            if (agent.fullPortrait != null)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                left: 0,
                right: 0,
                top: expanded ? 0 : 10,
                bottom: portraitBottom,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: expanded ? 0.3 : 1.0,
                  child: Image.network(
                    agent.fullPortrait!,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              left: 0,
              right: 0,
              bottom: 0,
              height: cardHeight,
              child: GestureDetector(
                onTap: onTap,
                child: _CardContent(
                  agent: agent,
                  expanded: expanded,
                  selectedAbility: selectedAbility,
                  onAbilityTap: onAbilityTap,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CardContent extends StatelessWidget {
  final AgentModel agent;
  final bool expanded;
  final int? selectedAbility;
  final ValueChanged<int> onAbilityTap;

  const _CardContent({
    required this.agent,
    required this.expanded,
    this.selectedAbility,
    required this.onAbilityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      color: bgBlue.withValues(alpha: 0.82),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (agent.role != null) _buildRole(agent.role!),
                const SizedBox(height: 8),
                Text(
                  agent.displayName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(child: _buildDescription()),
                const SizedBox(height: 12),
                if (expanded) ...[
                  _buildAbilities(),
                ] else ...[
                  _buildExpandHint(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRole(RoleModel role) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (role.displayIcon != null)
          Image.network(
            role.displayIcon!,
            height: 12,
            width: 12,
            color: Colors.white60,
          ),
        const SizedBox(width: 8),
        Text(
          role.displayName.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: valRed.withValues(alpha: 0.9),
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandHint() {
    return Center(
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          side: BorderSide(color: Colors.white24),
        ),
        color: Colors.white.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_outlined, color: Colors.white54, size: 16),
              const SizedBox(width: 8),
              Text(
                'tap for abilities',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontFamily: '',
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    final hasSelection = selectedAbility != null;
    final text = hasSelection
        ? agent.abilities[selectedAbility!].description
        : agent.description;
    final title =
        hasSelection ? agent.abilities[selectedAbility!].displayName : null;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: ShaderMask(
        key: ValueKey(hasSelection ? 'ability_$selectedAbility' : 'bio'),
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, 0.85, 1.0],
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: valRed,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white60,
                  height: 1.6,
                  fontFamily: '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbilities() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(agent.abilities.length, (index) {
        final ability = agent.abilities[index];
        final isSelected = selectedAbility == index;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () => onAbilityTap(index),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  shape: BeveledRectangleBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    side: BorderSide(
                      color: isSelected ? valRed : Colors.white30,
                      width: isSelected ? 2 : 1.5,
                    ),
                  ),
                  color: isSelected
                      ? valRed.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.1),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: ability.displayIcon != null
                        ? Padding(
                            padding: const EdgeInsets.all(9),
                            child: Image.network(
                              ability.displayIcon!,
                              color: isSelected ? valRed : Colors.white70,
                              errorBuilder: (_, __, ___) => Icon(
                                _slotIcon(ability.slot),
                                color: isSelected ? valRed : Colors.white70,
                                size: 20,
                              ),
                            ),
                          )
                        : Icon(
                            _slotIcon(ability.slot),
                            color: isSelected ? valRed : Colors.white70,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  IconData _slotIcon(String slot) {
    return switch (slot) {
      'Ability1' => Icons.looks_one_outlined,
      'Ability2' => Icons.looks_two_outlined,
      'Grenade' => Icons.flash_on_outlined,
      'Ultimate' => Icons.auto_awesome,
      'Passive' => Icons.shield_outlined,
      _ => Icons.circle_outlined,
    };
  }
}
