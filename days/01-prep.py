def model(dbt, session):
    # Imports must be in function body due to bug in dbt-duckdb
    from pathlib import Path

    import pandas as pd

    puzzle_input = Path("input/01.csv").read_text().split("\n\n")
    groups = [group.strip().split("\n") for group in puzzle_input]
    return (
        pd.Series(groups)
        .rename("calories")
        .to_frame()
        .explode("calories")
        .astype(int)
        .reset_index()
        .rename(columns={"index": "elf"})
    )
