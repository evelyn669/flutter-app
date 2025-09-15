/// package imports
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

///Local imports
import '../widgets/expansion_tile.dart';
import '../widgets/search_bar.dart';
import '../widgets/shared/mobile.dart'
    if (dart.library.html) '../widgets/shared/web.dart';
import 'helper.dart';
import 'model.dart';
import 'sample_view.dart';

/// Renders web layout
class WebLayoutPage extends StatefulWidget {
  /// Holds the selected control's category, etc.,
  const WebLayoutPage({this.sampleModel, this.category, Key key, this.subItem})
      : super(key: key);

  /// Holds [SampleModel]
  final SampleModel sampleModel;

  /// Hold the selected control's category information
  final WidgetCategory category;

  ///Holds the sample details
  final SubItem subItem;

  @override
  _WebLayoutPageState createState() => _WebLayoutPageState();
}

class _WebLayoutPageState extends State<WebLayoutPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey sampleInputKey = GlobalKey<State>();
  GlobalKey sampleOutputKey = GlobalKey<State>();

  _SampleInputContainer inputContainer;

  _SampleOutputContainer outputContainer;

  String selectSample;

  SampleModel model;
  WidgetCategory category;
  SubItem sample;
  List<SubItem> subItems;
  String orginText;
  @override
  void initState() {
    model = widget.sampleModel;
    category = widget.category;
    sample = widget.subItem;
    orginText = sample.parentIndex != null
        ? sample.control.title +
            ' > ' +
            sample.control.subItems[sample.parentIndex].title +
            ' > ' +
            sample.control.subItems[sample.parentIndex]
                .subItems[sample.childIndex].title
        : sample.childIndex != null
            ? sample.control.title +
                ' > ' +
                widget.subItem.control.subItems[sample.childIndex].title +
                ' > ' +
                sample.title
            : sample.control.title + ' > ' + sample.title;
    subItems = sample.parentIndex != null
        ? sample.control.subItems[sample.parentIndex]
            .subItems[sample.childIndex].subItems
        : null;
    model.addListener(_handleChange);
    super.initState();
  }

  ///Notify the framework by calling this method
  void _handleChange() {
    if (mounted) {
      setState(() {
        /// The listenable's state was changed already.
      });
    }
  }

  @override
  void dispose() {
    model.removeListener(_handleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///Checking the download button is currently hovered
    bool isHoveringDownloadButton = false;
    return Scaffold(
        key: scaffoldKey,
        drawer: (MediaQuery.of(context).size.width > 768)
            ? Container()
            : SizedBox(
                width: MediaQuery.of(context).size.width *
                    (MediaQuery.of(context).size.width < 500 ? 0.65 : 0.4),
                child: Drawer(
                    key: const PageStorageKey<String>('pagescrollmaintain'),
                    child: Container(
                        color: model.webBackgroundColor,
                        padding: const EdgeInsets.only(top: 5),
                        child: _SampleInputContainer(
                            sampleModel: model,
                            category: category,
                            key: sampleInputKey,
                            webLayoutPageState: this)))),
        endDrawer: showWebThemeSettings(model),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                BoxShadow(
                  color: model.paletteColor,
                  offset: const Offset(0, 2.0),
                  blurRadius: 0.25,
                )
              ]),
              child: AppBar(
                leading: (MediaQuery.of(context).size.width > 768)
                    ? Container()
                    : HandCursor(
                        child: IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            if (outputContainer != null) {
                              final GlobalKey globalKey = outputContainer.key;
                              final _SampleOutputContainerState
                                  _outputContainerState =
                                  globalKey.currentState;
                              if (_outputContainerState.outputScaffoldKey
                                  .currentState.isEndDrawerOpen) {
                                Navigator.pop(context);
                              }
                            }
                            scaffoldKey.currentState.openDrawer();
                          },
                        ),
                      ),
                automaticallyImplyLeading:
                    MediaQuery.of(context).size.width <= 768,
                elevation: 0.0,
                backgroundColor: model.paletteColor,
                titleSpacing:
                    MediaQuery.of(context).size.width <= 768 ? 0 : -30,
                title: Row(children: <Widget>[
                  const Text('Small Business Management',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 0.53,
                          fontFamily: 'Roboto-Medium')),
                  Container(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color.fromRGBO(245, 188, 14, 1)),
                      child: const Text(
                        'BETA',
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.26,
                            fontFamily: 'Roboto-Medium',
                            color: Colors.black),
                      ))
                ]),
                actions: <Widget>[
                  model.isMobileResolution
                      ? Container(height: 0, width: 9)
                      : Container(
                          child: Container(
                              padding: const EdgeInsets.only(top: 0, right: 20),
                              width: MediaQuery.of(context).size.width * 0.215,
                              height:
                                  MediaQuery.of(context).size.height * 0.0445,
                              child: HandCursor(
                                child: SearchBar(
                                  sampleListModel: model,
                                ),
                              ))),

                  ///download option
                  model.isMobileResolution
                      ? Container()
                      : Container(
                          alignment: Alignment.center,
                          child: Container(
                              width: 115,
                              height: 32,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white)),
                              child: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return MouseRegion(
                                    child: InkWell(
                                      hoverColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 9, 8, 9),
                                        child: Text('DOWNLOAD NOW',
                                            style: TextStyle(
                                                color: isHoveringDownloadButton
                                                    ? model.paletteColor
                                                    : Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Roboto-Medium')),
                                      ),
                                      onTap: () {
                                        launch(
                                            'https://www.syncfusion.com/downloads/flutter/confirm');
                                      },
                                    ),
                                    onHover: (PointerHoverEvent event) {
                                      isHoveringDownloadButton = true;
                                      setState(() {});
                                    },
                                    onExit: (PointerExitEvent event) {
                                      isHoveringDownloadButton = false;
                                      setState(() {});
                                    });
                              }))),
                  Container(
                    height: 60,
                    width: 60,
                    child: HandCursor(
                      child: IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          if (outputContainer != null) {
                            final GlobalKey globalKey = outputContainer.key;
                            final _SampleOutputContainerState
                                _outputContainerState = globalKey.currentState;
                            if (_outputContainerState.outputScaffoldKey
                                .currentState.isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                          }
                          scaffoldKey.currentState.openEndDrawer();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
        body: Material(
            child: Row(
          children: <Widget>[
            (MediaQuery.of(context).size.width <= 768)
                ? Container()
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.17,
                    child: inputContainer = _SampleInputContainer(
                        sampleModel: model,
                        category: category,
                        key: sampleInputKey,
                        webLayoutPageState: this)),
            outputContainer = _SampleOutputContainer(
                sampleModel: model,
                category: category,
                initialSample: sample,
                orginText: orginText,
                initialSubItems: subItems,
                key: sampleOutputKey,
                webLayoutPageState: this)
          ],
        )));
  }
}

///Expansion key for expansion tile container
class _ExpansionKey {
  _ExpansionKey({this.expansionIndex, this.isExpanded, this.globalKey});
  bool isExpanded;
  int expansionIndex;
  GlobalKey globalKey;
}

/// Renders samples titles in list view or in expansion tile,
/// in the left side of the web page
class _SampleInputContainer extends StatefulWidget {
  const _SampleInputContainer(
      {this.sampleModel, this.category, this.webLayoutPageState, this.key})
      : super(key: key);

  final SampleModel sampleModel;
  final WidgetCategory category;

  @override
  final Key key;

  final _WebLayoutPageState webLayoutPageState;

  @override
  State<StatefulWidget> createState() {
    return _SampleInputContainerState();
  }
}

class _SampleInputContainerState extends State<_SampleInputContainer> {
  SampleModel sampleModel;
  WidgetCategory category;

  List<_ExpansionKey> expansionKey;

  bool initialRender;

  /// Notify the framework
  void refresh() {
    initialRender = false;
    if (mounted) {
      setState(() {
        /// update the input changes
      });
    }
  }

  @override
  void initState() {
    expansionKey = <_ExpansionKey>[];
    initialRender = true;
    super.initState();
  }

  ///Get the widgets in expansionTile
  Widget _expandedChildren(
      SampleModel model, SubItem item, WidgetCategory category, int index) {
    GlobalKey<State> _currentGlobalKey;
    _ExpansionKey _currentExpansionKey;
    if (initialRender) {
      _currentGlobalKey = GlobalKey<State>();
      _currentExpansionKey = _ExpansionKey(
          expansionIndex: index,
          isExpanded: index == 0,
          globalKey: _currentGlobalKey);
      expansionKey.add(_currentExpansionKey);
    } else {
      if (expansionKey.isNotEmpty) {
        for (int i = 0; i < expansionKey.length; i++) {
          if (expansionKey[i].expansionIndex == index) {
            _currentExpansionKey = expansionKey[i];
            break;
          }
        }
      }
    }
    return item.subItems != null && item.subItems.isNotEmpty
        ? _TileContainer(
            key: _currentGlobalKey,
            category: category,
            sampleModel: model,
            expansionKey: _currentExpansionKey,
            webLayoutPageState: widget.webLayoutPageState,
            item: item)
        : Material(
            color: model.webBackgroundColor,
            child: HandCursor(
                child: InkWell(
                    hoverColor: Colors.grey.withOpacity(0.2),
                    onTap: () {
                      final GlobalKey globalKey =
                          widget.webLayoutPageState.outputContainer.key;
                      final _SampleOutputContainerState _outputContainerState =
                          globalKey.currentState;
                      if (_outputContainerState
                              .outputScaffoldKey.currentState.isEndDrawerOpen ||
                          widget.webLayoutPageState.scaffoldKey.currentState
                              .isDrawerOpen) {
                        Navigator.pop(context);
                      }
                      _outputContainerState.sample = item;
                      _outputContainerState.needTabs = false;
                      _outputContainerState.orginText =
                          widget.webLayoutPageState.sample.control.title +
                              ' > ' +
                              item.title;
                      if (model.currentSampleKey == null ||
                          model.currentSampleKey != item.key) {
                        _outputContainerState.refresh();
                      }
                    },
                    child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        alignment: Alignment.centerLeft,
                        child: Text(item.title,
                            style: TextStyle(
                                color: model.textColor,
                                fontSize: 13,
                                fontFamily: 'Roboto-Regular'))))));
  }

  List<Widget> _getSampleList(SampleModel model, WidgetCategory category) {
    final List<SubItem> _list =
        widget.webLayoutPageState.sample.control.subItems;
    final List<Widget> _children = <Widget>[];
    for (int i = 0; i < _list.length; i++) {
      final bool _isNeedSelect = widget.webLayoutPageState.selectSample == null
          ? widget.webLayoutPageState.sample.breadCrumbText ==
              _list[i].breadCrumbText
          : widget.webLayoutPageState.selectSample == _list[i].title;
      _children.add(Material(
          color: model.webBackgroundColor,
          child: _list[i].type != 'parent' && _list[i].type != 'child'
              ? HandCursor(
                  child: InkWell(
                  hoverColor: Colors.grey.withOpacity(0.2),
                  child: Container(
                      color: _isNeedSelect
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      child: Row(children: <Widget>[
                        Container(
                            color: _isNeedSelect
                                ? model.backgroundColor
                                : Colors.transparent,
                            width: 5,
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            alignment: Alignment.centerLeft,
                            child:
                                const Opacity(opacity: 0.0, child: Text('1'))),
                        Expanded(
                            child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 10, 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _list[i].title,
                                  style: TextStyle(
                                      color: _isNeedSelect
                                          ? model.backgroundColor
                                          : model.textColor),
                                ))),
                        _list[i].status != null
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: _list[i].status.toLowerCase() ==
                                            'new'
                                        ? const Color.fromRGBO(55, 153, 30, 1)
                                        : (_list[i].status.toLowerCase() ==
                                                'updated')
                                            ? const Color.fromRGBO(
                                                246, 117, 0, 1)
                                            : Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                padding:
                                    const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                                child: Text(_list[i].status,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10.5)))
                            : Container(),
                        _list[i].status != null
                            ? const Padding(padding: EdgeInsets.only(right: 5))
                            : Container(),
                      ])),
                  onTap: () {
                    final _SampleInputContainerState
                        _sampleInputContainerState =
                        widget.webLayoutPageState.sampleInputKey.currentState;
                    final GlobalKey globalKey =
                        widget.webLayoutPageState.outputContainer.key;
                    final _SampleOutputContainerState _outputContainerState =
                        globalKey.currentState;
                    if (_outputContainerState
                            .outputScaffoldKey.currentState.isEndDrawerOpen ||
                        widget.webLayoutPageState.scaffoldKey.currentState
                            .isDrawerOpen) {
                      Navigator.pop(context);
                    }
                    _outputContainerState.sample = _list[i];
                    _outputContainerState.needTabs = false;
                    _outputContainerState.orginText =
                        widget.webLayoutPageState.sample.control.title +
                            ' > ' +
                            _list[i].title;
                    widget.webLayoutPageState.selectSample = _list[i].title;
                    if (model.currentSampleKey == null ||
                        (_list[i].key != null
                            ? model.currentSampleKey != _list[i].key
                            : model.currentSampleKey !=
                                _list[i].subItems[0].key)) {
                      _sampleInputContainerState.refresh();
                      _outputContainerState.refresh();
                    }
                  },
                ))
              : _expandedChildren(model, _list[i], category, i)));
    }

    return _children;
  }

  @override
  Widget build(BuildContext context) {
    sampleModel = widget.sampleModel;
    category = widget.category;
    return Container(
        color: sampleModel.webBackgroundColor,
        height: MediaQuery.of(context).size.height - 45,
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 5),
              height: 40,
              child: HandCursor(
                  child: InkWell(
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                    ),
                    Container(
                        child: Icon(Icons.arrow_back,
                            size: 20, color: sampleModel.backgroundColor)),
                    Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          widget.webLayoutPageState.sample.control.title,
                          style: TextStyle(
                              color: sampleModel.backgroundColor,
                              fontSize: 16,
                              fontFamily: 'Roboto-Medium'),
                        )),
                    const Spacer(),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                  ],
                ),
                onTap: () {
                  changeCursorStyleOnNavigation();
                  Navigator.pop(context);
                  if (MediaQuery.of(context).size.width <= 768) {
                    Navigator.pop(context);
                  }
                },
              )),
            ),
            Expanded(
                child:
                    ListView(children: _getSampleList(sampleModel, category)))
          ],
        ));
  }
}

/// sample renders inside of this widget with tabs and without tabs
class _SampleOutputContainer extends StatefulWidget {
  const _SampleOutputContainer(
      {this.sampleModel,
      this.category,
      this.initialSample,
      this.webLayoutPageState,
      this.initialSubItems,
      this.orginText,
      this.key,
      this.routes})
      : super(key: key);

  final SampleModel sampleModel;

  @override
  final Key key;
  final String orginText;

  final SubItem initialSample;
  final WidgetCategory category;
  final List<SubItem> initialSubItems;

  final _WebLayoutPageState webLayoutPageState;

  final Map<String, WidgetBuilder> routes;

  @override
  State<StatefulWidget> createState() {
    return _SampleOutputContainerState();
  }
}

class _SampleOutputContainerState extends State<_SampleOutputContainer> {
  SubItem sample;
  List<SubItem> subItems;
  bool needTabs;
  String orginText;
  int tabIndex;
  GlobalKey<ScaffoldState> outputScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State> _propertiesPanelKey = GlobalKey<State>();
  GlobalKey<State> outputKey = GlobalKey<State>();
  _PropertiesPanel _propertiesPanel;
  bool _initialRender;

  @override
  void initState() {
    _initialRender = true;
    orginText = widget.orginText;
    super.initState();
  }

  /// Notify the framework
  void refresh() {
    _initialRender = false;
    if (mounted) {
      setState(() {
        /// update the sample and sample details changes
      });
    }
  }

  @override
  void dispose() {
    tabIndex = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SampleModel _model = widget.sampleModel;
    if (_initialRender && widget.initialSubItems != null) {
      needTabs = true;
      subItems = widget.initialSubItems;
    }
    final SubItem _sample = _initialRender ? widget.initialSample : sample;
    _propertiesPanel = _PropertiesPanel(
        sampleModel: _model,
        key: _propertiesPanelKey,
        webLayoutPageState: widget.webLayoutPageState);
    return Theme(
      data: ThemeData(
          brightness: _model.themeData.brightness,
          primaryColor: _model.backgroundColor),
      child: Expanded(
          child: Container(
              color: _model.webOutputContainerColor,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(_sample.title,
                          style: TextStyle(
                              color: _model.textColor,
                              letterSpacing: 0.39,
                              fontSize: 18,
                              fontFamily: 'Roboto-Medium'))),
                  Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          needTabs == true && subItems.length != 1
                              ? orginText + ' > ' + _sample.title
                              : orginText,
                          style: TextStyle(
                              color: _model.textColor.withOpacity(0.65),
                              fontSize: 14,
                              letterSpacing: 0.3,
                              fontFamily: 'Roboto-Regular'))),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Expanded(
                      child: Scaffold(
                          backgroundColor: _model.webOutputContainerColor,
                          key: outputScaffoldKey,
                          endDrawer: _propertiesPanel,
                          body: needTabs == true
                              ? DefaultTabController(
                                  initialIndex: tabIndex ??
                                      widget.webLayoutPageState.sample
                                          .sampleIndex,
                                  key: UniqueKey(),
                                  length: subItems.length,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: _model.webOutputContainerColor,
                                        border: Border.all(
                                            color:
                                                _model.themeData.brightness ==
                                                        Brightness.light
                                                    ? Colors.grey[300]
                                                    : Colors.transparent,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: _model.webInputColor,
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            _model.dividerColor,
                                                        width: 0.8)),
                                              ),
                                              padding: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      500
                                                  ? const EdgeInsets.fromLTRB(
                                                      2, 5, 2, 0)
                                                  : const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            ((MediaQuery.of(context)
                                                                            .size
                                                                            .width <=
                                                                        768 &&
                                                                    MediaQuery.of(context)
                                                                            .size
                                                                            .width >
                                                                        500)
                                                                ? 0.82
                                                                : 0.67),
                                                        child:
                                                            SingleChildScrollView(
                                                                key: PageStorageKey<
                                                                    String>((subItems
                                                                            .isNotEmpty
                                                                        ? subItems[0]
                                                                            .title
                                                                        : '') +
                                                                    'tabscroll'),
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: HandCursor(
                                                                    child: Material(
                                                                        color: _model.webInputColor,
                                                                        child: InkWell(
                                                                            hoverColor: _model.paletteColor.withOpacity(0.3),
                                                                            child: subItems.length == 1
                                                                                ? Container()
                                                                                : TabBar(
                                                                                    indicatorPadding: EdgeInsets.zero,
                                                                                    indicatorColor: _model.backgroundColor,
                                                                                    onTap: (int value) {
                                                                                      final GlobalKey globalKey = widget.webLayoutPageState.outputContainer.key;
                                                                                      final _SampleOutputContainerState _outputContainerState = globalKey.currentState;
                                                                                      _outputContainerState.sample = subItems[value];
                                                                                      _outputContainerState.needTabs = true;
                                                                                      _outputContainerState.subItems = subItems;
                                                                                      _outputContainerState.tabIndex = value;
                                                                                      if (_model.currentSampleKey == null || _model.currentSampleKey != _outputContainerState.sample.key) {
                                                                                        _outputContainerState.refresh();
                                                                                      }
                                                                                    },
                                                                                    labelColor: _model.backgroundColor,
                                                                                    unselectedLabelColor: _model.themeData.brightness == Brightness.dark ? Colors.white : const Color.fromRGBO(89, 89, 89, 1),
                                                                                    isScrollable: true,
                                                                                    tabs: _getTabs(subItems),
                                                                                  )))))),
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                          ),
                                                          Container(
                                                            height: 24,
                                                            width: 24,
                                                            child: HandCursor(
                                                              child: InkWell(
                                                                child: Icon(
                                                                    Icons.code,
                                                                    color: _model
                                                                        .webIconColor),
                                                                onTap: () {
                                                                  launch(_sample
                                                                      .codeLink);
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                          ),
                                                          _sample.needsPropertyPanel ==
                                                                  true
                                                              ? Container(
                                                                  height: 24,
                                                                  width: 24,
                                                                  child:
                                                                      HandCursor(
                                                                    child:
                                                                        InkWell(
                                                                      child: Icon(
                                                                          Icons
                                                                              .menu,
                                                                          color:
                                                                              _model.webIconColor),
                                                                      onTap:
                                                                          () {
                                                                        outputScaffoldKey
                                                                            .currentState
                                                                            .openEndDrawer();
                                                                      },
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    )
                                                  ])),
                                          Expanded(
                                              child: Container(
                                            color: _model.cardThemeColor,
                                            child: TabBarView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                children: _getTabViewChildren(
                                                    _model, subItems)),
                                          )),
                                        ],
                                      )))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: _model.webOutputContainerColor,
                                    border: Border.all(
                                        color: _model.themeData.brightness ==
                                                Brightness.light
                                            ? Colors.grey[300]
                                            : Colors.transparent,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: _model.webInputColor,
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: _model.dividerColor,
                                                  width: 0.8)),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                  child: Row(
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                  ),
                                                  Container(
                                                    height: 24,
                                                    width: 24,
                                                    child: HandCursor(
                                                        child: InkWell(
                                                      child: Icon(Icons.code,
                                                          color: _model
                                                              .webIconColor),
                                                      onTap: () {
                                                        launch(
                                                            _sample.codeLink);
                                                      },
                                                    )),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                  ),
                                                  _sample.needsPropertyPanel ==
                                                          true
                                                      ? Container(
                                                          height: 24,
                                                          width: 24,
                                                          child: HandCursor(
                                                              child: InkWell(
                                                            child: Icon(
                                                                Icons.menu,
                                                                color: _model
                                                                    .webIconColor),
                                                            onTap: () {
                                                              outputScaffoldKey
                                                                  .currentState
                                                                  .openEndDrawer();
                                                            },
                                                          )),
                                                        )
                                                      : Container(),
                                                ],
                                              )),
                                            ]),
                                      ),
                                      Expanded(
                                          child: Column(
                                        children: <Widget>[
                                          Expanded(
                                              child: Container(
                                            color: _model.cardThemeColor,
                                            child: _OutputContainer(
                                                key: GlobalKey(),
                                                subItem: _sample,
                                                sampleView: _model
                                                    .sampleWidget[_sample.key],
                                                sampleModel: _model),
                                          )),
                                          _sample.sourceLink != null &&
                                                  _sample.sourceLink != ''
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 10, 0, 15),
                                                    height: 40,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Source: ',
                                                          style: TextStyle(
                                                              color: _model
                                                                  .textColor
                                                                  .withOpacity(
                                                                      0.65),
                                                              fontSize: 12),
                                                        ),
                                                        InkWell(
                                                          onTap: () => launch(
                                                              _sample
                                                                  .sourceLink),
                                                          child: Text(
                                                              _sample
                                                                  .sourceText,
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .blue)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      )),
                                    ],
                                  )))),
                  _sample.description != null && _sample.description != ''
                      ? Container(
                          padding: const EdgeInsets.only(left: 10, top: 18),
                          alignment: Alignment.centerLeft,
                          child: Text(_sample.description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: _model.textColor,
                                  fontSize: 14,
                                  fontFamily: 'Roboto-Regular',
                                  letterSpacing: 0.3)))
                      : Container(),
                ],
              ))),
    );
  }

  /// Get tabs which length is equal to list length
  List<Widget> _getTabs(List<SubItem> list) {
    final List<Widget> _tabs = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      if (list.isNotEmpty) {
        final String _status = getStatusTag(list[i]);
        _tabs.add(Tab(
            child: Row(
          children: <Widget>[
            Text(list[i].title.toString() + (_status != '' ? '  ' : ''),
                style: const TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 14,
                    fontFamily: 'Roboto-Medium')),
            _status == ''
                ? Container()
                : Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: _status == 'New'
                          ? const Color.fromRGBO(55, 153, 30, 1)
                          : _status == 'Updated'
                              ? const Color.fromRGBO(246, 117, 0, 1)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _status == 'New' ? 'N' : _status == 'Updated' ? 'U' : '',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
          ],
        )));
      }
    }
    return _tabs;
  }

  /// Get tab view widgets which length is equal to list length
  List<Widget> _getTabViewChildren(SampleModel model, List<SubItem> list) {
    final List<Widget> _tabChildren = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      _tabChildren.add(Column(children: <Widget>[
        Expanded(
          child: Container(
              color: model.cardThemeColor,
              padding: const EdgeInsets.all(5.0),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: _OutputContainer(
                      key: GlobalKey(),
                      sampleModel: model,
                      subItem: list[i],
                      sampleView: model.sampleWidget[list[i].key]))),
        ),
        list[i].sourceLink != null && list[i].sourceLink != ''
            ? Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 15),
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Source: ',
                        style: TextStyle(
                            color: model.textColor.withOpacity(0.65),
                            fontSize: 12),
                      ),
                      InkWell(
                        onTap: () => launch(list[i].sourceLink),
                        child: Text(list[i].sourceText,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ]));
    }
    return _tabChildren;
  }
}

/// Output sample renders inside of this widget
class _OutputContainer extends StatefulWidget {
  _OutputContainer({this.sampleModel, this.key, this.subItem, this.sampleView})
      : super(key: key);

  final SampleModel sampleModel;

  @override
  final Key key;

  final SubItem subItem;

  final Function sampleView;

  @override
  State<StatefulWidget> createState() {
    return _OutputContainerState();
  }
}

class _OutputContainerState extends State<_OutputContainer> {
  @override
  Widget build(BuildContext context) {
    widget.sampleModel.oldWindowSize = widget.sampleModel.oldWindowSize == null
        ? MediaQuery.of(context).size
        : widget.sampleModel.currentWindowSize;

    widget.sampleModel.currentWindowSize = MediaQuery.of(context).size;
    if (widget.sampleModel.oldWindowSize.width !=
            widget.sampleModel.currentWindowSize.width ||
        widget.sampleModel.oldWindowSize.height !=
            widget.sampleModel.currentWindowSize.height) {
      widget.sampleModel.currentSampleKey = widget.subItem.key;
      return Container(child: widget.sampleModel.currentRenderSample);
    } else {
      widget.sampleModel.currentRenderSample =
          widget.sampleView(GlobalKey<State>());
      widget.sampleModel.currentSampleKey = widget.subItem.key;
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              brightness: widget.sampleModel.themeData.brightness,
              primaryColor: widget.sampleModel.backgroundColor),
          initialRoute: widget.subItem.breadCrumbText,
          routes: <String, WidgetBuilder>{
            widget.subItem.breadCrumbText: (BuildContext cotext) => Scaffold(
                backgroundColor: widget.sampleModel.cardThemeColor,
                body: widget.sampleModel.currentRenderSample)
          },
          home: Builder(builder: (BuildContext context) {
            return Scaffold(
                backgroundColor: widget.sampleModel.cardThemeColor,
                body: widget.sampleView(GlobalKey<State>()));
          }));
    }
  }
}

/// Get the Proeprty panel widget in the drawer
class _PropertiesPanel extends StatefulWidget {
  _PropertiesPanel({this.sampleModel, this.webLayoutPageState, this.key})
      : super(key: key);
  final SampleModel sampleModel;

  @override
  final Key key;

  final _WebLayoutPageState webLayoutPageState;

  @override
  State<StatefulWidget> createState() {
    return _PropertiesPanelState();
  }
}

class _PropertiesPanelState extends State<_PropertiesPanel> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey _sampleKey = widget.sampleModel.currentRenderSample.key;
    final SampleViewState _sampleViewState = _sampleKey.currentState;
    final Widget _settingPanelContent = _sampleViewState.buildSettings(context);
    return Theme(
      data: ThemeData(
          brightness: widget.sampleModel.themeData.brightness,
          primaryColor: widget.sampleModel.backgroundColor),
      child: Drawer(
          elevation: 3,
          child: SizedBox(
              width: 280,
              child: Container(
                  decoration: BoxDecoration(
                    color: widget.sampleModel.cardThemeColor,
                    border: Border.all(
                        color: const Color.fromRGBO(0, 0, 0, 0.12), width: 2),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: ListView(
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Properties',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                HandCursor(
                                    child: IconButton(
                                  icon: Icon(Icons.close,
                                      color: widget.sampleModel.webIconColor),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ))
                              ]),
                          Container(
                              padding: const EdgeInsets.only(right: 5),
                              height: 600,
                              width: 238,
                              child: _settingPanelContent)
                        ],
                      ))))),
    );
  }
}

/// Get the sample list in an expansion tile
class _TileContainer extends StatefulWidget {
  _TileContainer(
      {this.sampleModel,
      this.category,
      this.webLayoutPageState,
      this.item,
      this.expansionKey,
      this.key})
      : super(key: key);

  final SampleModel sampleModel;
  @override
  final Key key;
  final SubItem item;
  final WidgetCategory category;
  final _WebLayoutPageState webLayoutPageState;
  final _ExpansionKey expansionKey;

  @override
  State<StatefulWidget> createState() {
    return _TileContainerState();
  }
}

class _TileContainerState extends State<_TileContainer> {
  @override
  Widget build(BuildContext context) {
    final SampleModel _model = widget.sampleModel;
    return HandCursor(
        child: CustomExpansionTile(
      headerBackgroundColor: _model.webBackgroundColor,
      onExpansionChanged: (bool value) {
        final _SampleInputContainerState _sampleInputContainerState =
            widget.webLayoutPageState.sampleInputKey.currentState;
        final List<_ExpansionKey> expansionKey =
            _sampleInputContainerState.expansionKey;
        for (int k = 0; k < expansionKey.length; k++) {
          if (expansionKey[k].expansionIndex ==
              widget.expansionKey.expansionIndex) {
            expansionKey[k].isExpanded = value;
            break;
          }
        }
      },
      initiallyExpanded: true,
      title: Text(widget.item.title,
          style: TextStyle(
              color: _model.textColor,
              fontSize: 13,
              letterSpacing: -0.19,
              fontFamily: 'Roboto-Medium')),
      key: PageStorageKey<String>(widget.item.title),
      children: _getNextLevelChildren(
          _model, widget.item.subItems, widget.item.title),
    ));
  }

  /// Get expanded children
  List<Widget> _getNextLevelChildren(
      SampleModel model, List<SubItem> list, String text) {
    final List<Widget> _nextLevelChildren = <Widget>[];
    final SubItem currenSample = widget.webLayoutPageState.sample;
    if (list != null && list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        final String _status = getStatusTag(list[i]);
        bool _isNeedSelect = false;
        if (list[i].subItems != null) {
          for (int j = 0; j < list[i].subItems.length; j++) {
            if (currenSample.breadCrumbText ==
                list[i].subItems[j].breadCrumbText) {
              _isNeedSelect = true;
              break;
            } else {
              continue;
            }
          }
        } else {
          _isNeedSelect = currenSample.breadCrumbText == list[i].breadCrumbText;
        }
        _nextLevelChildren.add(list[i].type == 'sample'
            ? Material(
                color: model.webBackgroundColor,
                child: HandCursor(
                    child: InkWell(
                        hoverColor: Colors.grey.withOpacity(0.2),
                        onTap: () {
                          final _SampleInputContainerState
                              _sampleInputContainerState = widget
                                  .webLayoutPageState
                                  .sampleInputKey
                                  .currentState;
                          final GlobalKey _globalKey =
                              widget.webLayoutPageState.outputContainer.key;
                          final _SampleOutputContainerState
                              _outputContainerState = _globalKey.currentState;
                          if (_outputContainerState.outputScaffoldKey
                                  .currentState.isEndDrawerOpen ||
                              widget.webLayoutPageState.scaffoldKey.currentState
                                  .isDrawerOpen) {
                            Navigator.pop(context);
                          }
                          _outputContainerState.sample = list[i];
                          _outputContainerState.needTabs = false;
                          _outputContainerState.orginText =
                              widget.webLayoutPageState.sample.control.title +
                                  ' > ' +
                                  text +
                                  ' > ' +
                                  list[i].title;

                          widget.webLayoutPageState.selectSample = widget
                              .webLayoutPageState.selectSample = list[i].title;
                          widget.webLayoutPageState.sample =
                              list[i].subItems != null
                                  ? list[i].subItems[0]
                                  : list[i];
                          if (model.currentSampleKey == null ||
                              (list[i].key != null
                                  ? model.currentSampleKey != list[i].key
                                  : model.currentSampleKey !=
                                      list[i].subItems[0].key)) {
                            _sampleInputContainerState.refresh();
                            _outputContainerState.refresh();
                          }
                        },
                        child: Container(
                            color: _isNeedSelect
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.transparent,
                            child: Row(children: <Widget>[
                              Container(
                                  width: 5,
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      const EdgeInsets.fromLTRB(1, 10, 10, 10),
                                  color: _isNeedSelect
                                      ? model.backgroundColor
                                      : Colors.transparent,
                                  child: const Opacity(
                                      opacity: 0.0, child: Text('1'))),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 10, 10),
                                      child: Text(list[i].title,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Roboto-Regular',
                                              color: _isNeedSelect
                                                  ? model.backgroundColor
                                                  : model.textColor)))),
                              Container(
                                  decoration: BoxDecoration(
                                      color: (_status != null && _status != '')
                                          ? (_status == 'New'
                                              ? const Color.fromRGBO(
                                                  55, 153, 30, 1)
                                              : const Color.fromRGBO(
                                                  246, 117, 0, 1))
                                          : Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0))),
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                                  child: Text(_status,
                                      style: const TextStyle(
                                          fontSize: 10.5,
                                          color: Colors.white))),
                              _status != null && _status != ''
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 5))
                                  : Container(),
                            ])))))
            : Material(
                color: model.webBackgroundColor,
                child: InkWell(
                  hoverColor: Colors.grey.withOpacity(0.2),
                  child: Container(
                      color: _isNeedSelect
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      child: Row(children: <Widget>[
                        Container(
                            width: 5,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                left: 1, top: 7, bottom: 7),
                            color: _isNeedSelect
                                ? model.backgroundColor
                                : Colors.transparent,
                            child:
                                const Opacity(opacity: 0.0, child: Text('1'))),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                    left: 18, top: 7, bottom: 7),
                                child: Text(list[i].title,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Roboto-Regular',
                                        color: _isNeedSelect
                                            ? model.backgroundColor
                                            : model.textColor)))),
                        _status != null && _status != ''
                            ? Container(
                                decoration: BoxDecoration(
                                    color: _status == 'New'
                                        ? const Color.fromRGBO(55, 153, 30, 1)
                                        : const Color.fromRGBO(246, 117, 0, 1),
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))),
                                padding:
                                    const EdgeInsets.fromLTRB(5, 2.7, 5, 2.7),
                                child: Text(_status,
                                    style: const TextStyle(
                                        fontSize: 10.5, color: Colors.white)))
                            : Container(),
                        _status != null && _status != ''
                            ? const Padding(padding: EdgeInsets.only(right: 5))
                            : Container(),
                      ])),
                  onTap: () {
                    final _SampleInputContainerState
                        _sampleInputContainerState =
                        widget.webLayoutPageState.sampleInputKey.currentState;
                    final GlobalKey _globalKey =
                        widget.webLayoutPageState.outputContainer.key;
                    final _SampleOutputContainerState _outputContainerState =
                        _globalKey.currentState;
                    if (list[i].subItems != null &&
                        list[i].subItems.isNotEmpty) {
                      _outputContainerState.subItems = list[i].subItems;
                      _outputContainerState.sample = list[i].subItems[0];
                      _outputContainerState.tabIndex = 0;
                      _outputContainerState.needTabs = true;
                    } else {
                      _outputContainerState.sample = list[i];
                      _outputContainerState.needTabs = false;
                    }
                    if (_outputContainerState
                            .outputScaffoldKey.currentState.isEndDrawerOpen ||
                        widget.webLayoutPageState.scaffoldKey.currentState
                            .isDrawerOpen) {
                      Navigator.pop(context);
                    }
                    _outputContainerState.orginText =
                        widget.webLayoutPageState.sample.control.title +
                            ' > ' +
                            text +
                            ' > ' +
                            list[i].title;

                    widget.webLayoutPageState.selectSample = list[i].title;
                    widget.webLayoutPageState.sample = list[i].subItems != null
                        ? list[i].subItems[0]
                        : list[i];
                    if (model.currentSampleKey == null ||
                        (list[i].key != null
                            ? model.currentSampleKey != list[i].key
                            : model.currentSampleKey !=
                                list[i].subItems[0].key)) {
                      _sampleInputContainerState.refresh();
                      _outputContainerState.refresh();
                    }
                  },
                )));
      }
    }
    return _nextLevelChildren;
  }
}
