{
  config,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
in /*qml*/ ''
QMainWindow,
QDialog,
QDockWidget {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QLabel {
  color: ${colors.base05};
  background-color: transparent;
}

QLineEdit,
QTextEdit,
QPlainTextEdit,
QSpinBox,
QDoubleSpinBox {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QLineEdit:focus,
QTextEdit:focus,
QPlainTextEdit:focus,
QSpinBox:focus,
QDoubleSpinBox:focus {
  border: 1px solid ${colors.base03};
}

QPushButton {
  background-color: ${colors.base03};
  color: ${colors.base04};
}

QPushButton:hover {
  background-color: ${colors.base0D};
  color: ${colors.base05};
}

QPushButton:pressed {
  border: 1px solid ${colors.base05};
}

QToolBar {
  background-color: ${colors.base00};
  color: white;
}

QMenuBar {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QMenu {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QMenu::item:selected {
  background-color: ${colors.base02};
}

QTreeView,
QListView,
QTableView {
  background-color: ${colors.base00};
  color: ${colors.base05};
  alternate-background-color: ${colors.base01};
}

QTreeView::item:selected,
QListView::item:selected,
QTableView::item:selected {
  background-color: ${colors.base02};
}

QComboBox {
  background-color: ${colors.base01};
  color: ${colors.base05};
}

QComboBox QAbstractItemView {
  background-color: ${colors.base00};
  selection-background-color: ${colors.base02};
}

QCheckBox {
  color: ${colors.base00};
}

QCheckBox::indicator {
  background-color: ${colors.base00};
}

QCheckBox::indicator:checked {
  image: url(qss:images_classic/check-mark-white.png);
}

QRadioButton {
  color: ${colors.base05};
}

QGroupBox {
  background-color: ${colors.base01};
  color: ${colors.base05};
}

QStatusBar {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QToolTip {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QSintActionGroup QFrame[class="content"] {
  color: ${colors.base05};
}

QSintActionGroup QFrame[class="content"] QLabel,
QSintActionGroup QFrame[class="content"] QLineEdit,
QSintActionGroup QFrame[class="content"] QTextEdit,
QSintActionGroup QFrame[class="content"] QPlainTextEdit,
QSintActionGroup QFrame[class="content"] QSpinBox,
QSintActionGroup QFrame[class="content"] QDoubleSpinBox,
QSintActionGroup QFrame[class="content"] QComboBox,
QSintActionGroup QFrame[class="content"] QCheckBox,
QSintActionGroup QFrame[class="content"] QRadioButton {
  color: ${colors.base05};
  background-color: transparent;
}

QSintActionGroup QFrame[class="content"] * {
  color: ${colors.base05};
}

QSintActionGroup {
  color: ${colors.base05};
}

QSintActionGroup QGroupBox,
QSintActionGroup QGroupBox::title {
  color: ${colors.base05};
}

QSintActionGroup QFrame[class="header"] {
  color: ${colors.base05};
}

QSintActionGroup QToolButton[class="header"] {
  color: ${colors.base05};
  text-align: left;
  font-weight: bold;
  border: none;
  margin: 0px;
  padding: 0px;
}

QSintActionGroup QFrame[class="header"]:hover {
  color: ${colors.base05};
}

GuiNotificationLabel {
  background-color: ${colors.base00};
  color: ${colors.base05};
  border-radius: 4px ${colors.base0D};
  padding: 8px;
}

GuiPropertyEditor--PropertyEditor {
  qproperty-groupTextColor: ${colors.base05};
  qproperty-groupBackground: ${colors.base00};
  alternate-background-color: ${colors.base01};
}

QTabWidget::tab-bar {
  alignment: left;
}

QTabBar::tab {
  background-color: ${colors.base01};
  color: ${colors.base05};
  border: 1px solid ${colors.base0D};
  border-top: none;
  padding: 4px 8px;
  margin-right: 2px;
}

QTabBar::tab:selected {
  background-color: ${colors.base02};
  color: ${colors.base05};
  border: 1px solid ${colors.base0D};
  border-top: none;
}

QTabBar::tab:hover:!selected {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QScrollBar:horizontal {
  height: 8px;
  background-color: rgba(255, 255, 255, 0.05);
  border: none;
  margin: 0px;
}

QScrollBar:vertical {
  width: 8px;
  background-color: rgba(255, 255, 255, 0.05);
  border: none;
  margin: 0px;
}

QScrollBar::handle:horizontal {
  background-color: rgba(255, 255, 255, 0.3);
  border: none;
  min-width: 20px;
  margin: 0px;
}

QScrollBar::handle:horizontal:hover {
  background-color: rgba(255, 255, 255, 0.5);
}

QScrollBar::handle:horizontal:focus {
  background-color: ${colors.base01};
  border: none;
}

QScrollBar::handle:vertical {
  background-color: rgba(255, 255, 255, 0.3);
  border: none;
  min-height: 20px;
  margin: 0px;
}

QScrollBar::handle:vertical:hover {
  background-color: rgba(255, 255, 255, 0.5);
}

QScrollBar::handle:vertical:focus {
  background-color: ${colors.base00};
  border: none;
}

QScrollBar::add-line:horizontal,
QScrollBar::sub-line:horizontal,
QScrollBar::add-line:vertical,
QScrollBar::sub-line:vertical {
  width: 0px;
  height: 0px;
  border: none;
  background: none;
}

QScrollBar::up-arrow:horizontal,
QScrollBar::down-arrow:horizontal,
QScrollBar::up-arrow:vertical,
QScrollBar::down-arrow:vertical {
  width: 0px;
  height: 0px;
  background: none;
}

QScrollBar::add-page:horizontal,
QScrollBar::sub-page:horizontal,
QScrollBar::add-page:vertical,
QScrollBar::sub-page:vertical {
  background: transparent;
}

QScrollBar::handle:horizontal:pressed,
QScrollBar::handle:vertical:pressed {
  background-color: ${colors.base00};
}

QScrollBar:horizontal:disabled,
QScrollBar:vertical:disabled {
  background-color: rgba(255, 255, 255, 0.02);
}

QScrollBar::handle:horizontal:disabled,
QScrollBar::handle:vertical:disabled {
  background-color: rgba(255, 255, 255, 0.1);
}

QScrollBar::corner {
  background-color: rgba(255, 255, 255, 0.05);
  border: none;
}

QStackedWidget > QWidget {
  background-color: ${colors.base00} !important;
  color: ${colors.base05} !important;
}

QStackedWidget > QWidget QPushButton {
  background-color: ${colors.base00} !important;
  color: ${colors.base05} !important;
}

QStackedWidget > QWidget QPushButton:hover {
  background-color: ${colors.base01} !important;
}

QStackedWidget > QWidget QCheckBox {
  background-color: transparent !important;
  color: ${colors.base05} !important;
  border: none !important;
}

QStackedWidget > QWidget QCheckBox::indicator {
  background-color: ${colors.base00} !important;
}

QStackedWidget > QWidget QCheckBox::indicator:checked {
  background-color: ${colors.base01} !important;
}

QStackedWidget > QWidget QScrollArea QPushButton {
  background-color: ${colors.base00} !important;
  color: ${colors.base05} !important;
  border: 1px solid ${colors.base03} !important;
}

QStackedWidget > QWidget QScrollArea QPushButton:hover {
  background-color: ${colors.base01} !important;
  color: ${colors.base05} !important;
  border: 1px solid ${colors.base0D} !important;
}

QStackedWidget > QWidget QScrollArea QPushButton QLabel {
  background-color: transparent !important;
  color: ${colors.base05} !important;
  border: none !important;
}

QStackedWidget > QWidget QScrollArea QPushButton:hover QLabel {
  background-color: transparent !important;
  color: ${colors.base05} !important;
  border: none ${colors.base0D} !important;
}

QStackedWidget > QWidget QWidget QPushButton:hover {
  background-color: ${colors.base01} !important;
  color: ${colors.base05} !important;
  border: none !important;
}

QStackedWidget > QWidget QWidget QPushButton:hover QLabel {
  background-color: ${colors.base01} !important;
  color: ${colors.base05} !important;
  border: none !important;
}

QListView QPushButton,
QScrollArea QPushButton {
  background-color: ${colors.base00} !important;
  color: ${colors.base05} !important;
  border: 1px solid ${colors.base03} !important;
}

QStackedWidget > QWidget QScrollArea QLabel {
  background-color: transparent !important;
  color: ${colors.base05} !important;
  font-weight: bold;
}

QStackedWidget > QWidget > QVBoxLayout > QScrollArea > QWidget > QVBoxLayout > QLabel {
  background-color: transparent !important;
  color: ${colors.base05} !important;
  font-weight: bold;
}

QStackedWidget > QWidget QPushButton {
  background-color: ${colors.base00} !important;
  color: ${colors.base05} !important;
  border: 1px solid ${colors.base03} !important;
  border-radius: 4px;
  padding: 6px 12px;
}

QStackedWidget > QWidget QPushButton:hover {
  background-color: ${colors.base01} !important;
  border-color: ${colors.base0D} !important;
}

QStackedWidget > QWidget QCheckBox {
  background-color: transparent !important;
  color: ${colors.base04} !important;
  border: none !important;
}

QStackedWidget > QWidget QCheckBox::indicator {
  background-color: ${colors.base00} !important;
  border: 1px solid ${colors.base03} !important;
  border-radius: 2px;
  width: 16px;
  height: 16px;
}

QStackedWidget > QWidget QCheckBox::indicator:checked {
  background-color: ${colors.base01} !important;
  border: 1px solid  !important;
}

QStackedWidget > QWidget QCheckBox::indicator:hover {
  border-color: ${colors.base0D} !important;
}

QStackedWidget > QWidget QScrollArea {
  background-color: ${colors.base00} !important;
  border-top: 2px solid ${colors.base03} !important;
  border-bottom: 2px solid ${colors.base03} !important;
}

QStackedWidget > QWidget QScrollArea > QWidget {
  background-color: ${colors.base00} !important;
}

QStackedWidget > QWidget QScrollArea QWidget {
  background-color: ${colors.base01} !important;
}

QStackedWidget > QWidget QScrollArea QListView {
  background-color: ${colors.base00} !important;
}

QStackedWidget > QWidget > QVBoxLayout > QScrollArea > QWidget > QVBoxLayout > QListView {
  background-color: ${colors.base00} !important;
}

FileCardView {
  background-color: ${colors.base01} !important;
}

QStackedWidget > QWidget QListView::item {
  background-color: ${colors.base00} !important;
  color: ${colors.base05} !important;
}

QStackedWidget > QWidget QListView::item:hover {
  background-color: ${colors.base01} !important;
  border-color: ${colors.base0D} !important;
}

QStackedWidget > QWidget QListView::item:selected {
  background-color: ${colors.base02} !important;
  border-color: ${colors.base0D} !important;
}

GuiTreePanel {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

GuiOverlayTabWidget {
  background-color: transparent;
}

GuiView3DInventorViewer {
  background-color: ${colors.base00};
}

GuiPrefCheckBox {
  color: ${colors.base05};
  background-color: transparent;
}

GuiPrefComboBox {
  background-color: ${colors.base00};
  color: ${colors.base05};
  border: 1px solid ${colors.base03};
}

GuiPrefLineEdit {
  background-color: ${colors.base00};
  color: ${colors.base05};
  border: 1px solid ${colors.base03};
}

GuiPrefSpinBox {
  background-color: ${colors.base00};
  color: ${colors.base05};
  border: 1px solid ${colors.base03};
}

QWidget[objectName="StyleSheets"] {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QWidget[objectName="OverlayStyleSheets"] {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QWidget[objectName="ThemeAccentColor1"] {
  border: 2px solid ${colors.base03};
}

QWidget[objectName="ThemeAccentColor2"] {
  border: 2px solid ${colors.base03};
}

QWidget[objectName="ThemeAccentColor3"] {
  border: 2px solid ${colors.base03};
}

GuiDialog--DlgPreferences {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

GuiDialog--DlgMacroExecute {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

GuiDialog--DlgCustomToolbars {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

GuiTaskView--TaskAppearance {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

GuiTaskView--TaskSelectLinkProperty {
  background-color: ${colors.base00};
  color: ${colors.base05};
}

QProgressBar {
  background-color: ${colors.base00};
  color: ${colors.base05};
  border: 1px solid ${colors.base03};
  text-align: center;
}

QProgressBar::chunk {
  background-color: ${colors.base01};
}

QSlider {
  background-color: transparent;
}

QSlider::groove:horizontal {
  background-color: ${colors.base00};
  color: ${colors.base05};
  border: 1px solid ${colors.base03};
  height: 4px;
}

QSlider::handle:horizontal {
  background-color: ${colors.base00};
  color: ${colors.base05};
  width: 12px;
  margin: -4px 0;
}
''
