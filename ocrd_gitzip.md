# OCRD-GITZIP

OCRD-GITZIP is an extension of [OCRD-ZIP](ocrd_zip) to version control any changes in a Git
index contained in the ZIP file.

For space efficiency and to prevent accidental untracked changes, the git
repository MUST be stored bare, i.e. without a manifested working tree, only
containing the contents of the `.git` directory.

## Invariants

### Working tree must be OCRD-ZIP

OCRD-GITZIP is strictly an extension of OCRD-ZIP, the working tree of the
repository must satisfy all [invariants for OCRD-ZIP](ocrd_zip#invariants)

### No .gitignore of data

The `.gitignore` mechanism to ignore files should not be used for files in `/data`.

### One and only one branch `master`

The repository should contain a single branch named `master`.

## Algorithms

### Convert OCRD-GITZIP to OCRD-ZIP

To create an OCRD-ZIP `z` from an OCRD-GITZIP `g`:

1. Unzip `g` to `$TMPDIR`
2. `git-archive -C $TMPDIR --format=zip > z`

### Convert OCRD-ZIP to OCRD-GITZIP

1. `unzip -d $TMPDIR orig.zip`
2. `git -C $TMPDIR add .`
3. `git -C $TMPDIR commit -m 'initial'`
3. `git clone --bare $TMPDIR orig.git`
4. `zip -r orig.git.zip orig.git`

## Appendix A - IANA considerations

Proposed media type of OCRD-GITZIP: `application/vnd.ocrd+git+zip`

Proposed extension: `.ocrd.git.zip`
