c = get_config()

# Run all nodes interactively
# https://www.dataquest.io/blog/jupyter-notebook-tips-tricks-shortcuts/
c.InteractiveShell.ast_node_interactivity = "all"

# Automatically restore stored variables at startup.
# https://ipython-docs.readthedocs.io/en/latest/config/extensions/storemagic.html
c.StoreMagics.autorestore = True

c.InteractiveShellApp.exec_lines = [
    """
try:
    import matplotlib
    matplotlib.use('nbagg')
    import matplotlib.pyplot as plt
except ImportError:
    print('matplotlib not installed...')

try:
    import numpy as np
    np.set_printoptions(suppress=True)
except ImportError:
    print('numpy not installed...')

try:
    import pandas as pd
    pd.set_option('display.max_rows', 500, )
    pd.set_option('display.max_columns', 100, )
except ImportError:
    print('pandas not installed...')

try:
    import seaborn as sns
    sns.set(style='whitegrid', color_codes=True)
except ImportError:
    print('seaborn not installed...')

%load_ext autoreload
%autoreload 2
    """,
]
