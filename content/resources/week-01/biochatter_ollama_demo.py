"""Tiny BioChatter + Ollama demo for Week 1.

Run this from the blog repo root after starting Ollama:

    conda activate biochatter-agent
    python content/resources/week-01/biochatter_ollama_demo.py
"""

import warnings
from contextlib import redirect_stderr
from io import StringIO

warnings.simplefilter("ignore")

with redirect_stderr(StringIO()):
    from biochatter.llm_connect import OllamaConversation


    conversation = OllamaConversation(
        base_url="http://localhost:11434",
        prompts={},
        model_name="qwen2.5-coder:7b",
        correct=False,
    )

    question = """
    You are helping a beginner learn bioinformatics setup.
    The command `seqkit stats /workspace/demo/mini.fasta` returned these columns:
    file, format, type, num_seqs, sum_len, min_len, avg_len, max_len.
    Explain those columns in two short bullet points. Do not mention columns that
    are not listed here. Do not invent biological interpretation.
    """

    response, token_usage, correction = conversation.query(question)

print(response)
