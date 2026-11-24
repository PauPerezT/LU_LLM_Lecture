# Fundamentals of Large Language Models — companion material

Exercise and interactive walkthrough for the lecture
*Next-Word Prediction and Self-Attention*, in the Bachelor module
**Datensynthese und Sprachmodelle in der Medizin**.

Dr.-Ing. Paula A. Pérez-Toro

```
setup_github.sh                    one-command publish (needs the GitHub CLI)
docs/
  index.html                       the Self-Attention Explorer (GitHub Pages)
  notebooks/
    llm_student_exercise.ipynb     the "Your turn" exercise — 5 TODOs
    llm_solution.ipynb             the worked solution
tools/make_notebooks.py            regenerates both notebooks
```

## Publishing — the short way

With the [GitHub CLI](https://cli.github.com) installed and signed in (`gh auth login`):

```bash
cd luebeck-llm
./setup_github.sh <your-github-user>/<repository>
```

That sets the `REPO` constant in the page, commits, creates the repository, pushes,
and switches GitHub Pages on for `main` + `/docs`. It prints the two URLs at the end.

## Publishing — by hand

1. Push this repository to GitHub.
2. **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
   branch `main`, folder **`/docs`**. Save.
3. After a minute the page is live at
   `https://<user>.github.io/<repository>/`

Then **edit one line** at the top of the `<script>` in `docs/index.html`:

```js
const REPO = "USER/REPO";      // e.g. "pauperezt/luebeck-llm"
```

That line is what the *Open in Colab*, *View on GitHub* and *Solution notebook*
buttons are built from. Until you set it, the exercise tab shows a red reminder;
once set, the reminder disappears by itself.

The page is a single self-contained file — no frameworks, no CDN, no build step,
nothing fetched at run time. It works just as well opened from disk.

## The explorer

| tab | what the student can do |
|---|---|
| 1 · Tokens | see the sentence as token IDs, and that *penicillin* is two tokens |
| 2 · Embedding | move a token along the sentence and watch `e = E[x] + p` change |
| 3 · Q, K, V | drag `e₂` and watch key, score, attention and `Δe` recompute — the exercise, live |
| 4 · Attention | the full grid; toggle the causal mask and the softmax; click any row |
| 5 · Synthesis | the temperature slider, and sampling the next word |
| Your turn | the exercise, a reveal-able solution, and the notebook buttons |

## The exercise

Part A is the four lines from the *Your turn* slide; Part B builds the attention
pattern for the whole sentence; Part C is the generation loop. Five `TODO`s,
`numpy` only, runs offline, and the notebook checks the answers itself:

```
Part A
  OK     k2             you: [2. 0.]        expected: [2. 0.]
  OK     s              you: [4.243 2.828]  expected: [4.243 2.828]
  OK     alpha          you: [0.804 0.196]  expected: [0.805 0.195]
  OK     delta          you: [ 2.804 -1.196] expected: [ 2.805 -1.195]
all correct
```

Part B reproduces the slide's numbers exactly — the query *ceftriaxone* puts
**46 %** of its attention on *penicillin* and **28 %** on *allergy*.

Students who would rather not install anything can use the **Open in Colab**
button; the notebook needs nothing but `numpy`.

## A note on the numbers

Every value here is a toy chosen so the arithmetic can be done by hand. They are
not measured attention weights from a trained model, and the page says so in its
footer.
