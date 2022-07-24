# mapa-covid
Mapa com as informações de Covid-19

Documentação para uso do mapa via API do github:

<iframe id="github-iframe2" src="" style="width:100%; height:450px"></iframe>
      <script>
          fetch('https://api.github.com/repos/lucasdmazon/mapa-covid/contents/map_100k.html?ref=main')
              .then(function(response) {
                  return response.json();
              }).then(function(data) {
                  iframe = document.getElementById('github-iframe2');
                  iframe.src = 'data:text/html;base64,' + encodeURIComponent(data['content']);
              });
      </script>
