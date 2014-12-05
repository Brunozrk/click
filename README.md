# Click

*Click* tem como objetivo oferecer uma ferramenta web para controlar o saldo de horas de trabalho. Acesse em www.clickhoras.com

## Instalação

Baixe o repositório

    git clone git@github.com:Brunozrk/click.git

Instale as dependências

    bundle install

Configure o banco de dados

    rake db:create
    rake db:migrate
    rake db:seed ( Aqui cria-se um usuário [ bruce@wayne.com/12345678 ] com alguns apontamentos)

Rode os testes :+1:

    rspec

Execute o  [mailcatcher](http://mailcatcher.me/) para teste de e-mail no ambiente de desenvolvimento

    mailcatcher

Rode a aplicação :grin:

    rails s

## Contribuindo

Novas ideias e contribuintes são bem vindos!

### Como contribuir?

  * Acompanhe o projeto
    * Opine nos [Pull Requests](https://github.com/Brunozrk/click/pulls);
    * Dê sugestões, abra bugs e melhorias em [Issues](https://github.com/Brunozrk/click/issues).

  * Codificando
    * Faça o [fork](https://github.com/Brunozrk/click/fork) do projeto;
    * Cria uma branch com o nome da funcionalidade: `git checkout -b new-functionality`;
    * Faça commits específicos para cada implementação: `git commit -m 'Add validation to...'`;
    * Crie testes paras as novas funcionalidades! :relaxed:
    * Envie seu código para o github: `git push origin <new-functionality>`;
    * Faça um Pull Request para o repositório master!

  * Padronizando
    * Código sempre em inglês;
    * Nome de branch e commits em inglês;
    * Pull requests e issues em português;

  * Alguns links interessantes para serem seguidos
    * [ruby-style-guide](https://github.com/bbatsov/ruby-style-guide)
    * [rails-style-guide](https://github.com/bbatsov/rails-style-guide)
    * [betterspecs](http://betterspecs.org/)
    * Template utilizado http://www.almsaeedstudio.com/preview
