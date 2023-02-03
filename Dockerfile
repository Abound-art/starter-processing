FROM processing-base

RUN mkdir /algo
COPY algo.pde /algo/
COPY main.pde /algo/

CMD ["--sketch=/algo/", "--run"]