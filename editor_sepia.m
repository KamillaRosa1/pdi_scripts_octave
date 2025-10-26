% -------------------------------------------------------------------------
% editor_sepia.m
% Projeto: Filtro de Imagem Sepia com GUI
% -------------------------------------------------------------------------
% pkg install -forge image

function editor_sepia()
    % Funcao principal que inicia e constroi a GUI.
    clear all;
    close all;
    pkg load image;

    % 1. Estrutura de Dados (Handle Structure)
    h.img_rgb = []; % Armazena a imagem RGB original
    h.img_processada = []; % Armazena a ultima imagem Sepia processada

    % 2. Criacao da Figura Principal (Janela)
    h.fig = figure('Name', 'Editor Sépia Avançado (Octave)', 'Position', [100, 100, 1000, 600]);

    % 3. Area de Exibicao da Imagem (Axes)
    h.axes = axes('Parent', h.fig, 'Position', [0.35, 0.1, 0.6, 0.8]);
    title(h.axes, 'Carregue uma imagem para começar');
    axis(h.axes, 'off'); % Desativa eixos numericos padrao

    % 4. Botões de Ação
    % Botão de Carregamento da imagem
    h.btn_carregar = uicontrol(h.fig, 'Style', 'pushbutton', ...
                               'String', 'Carregar Imagem', ...
                               'Position', [50, 500, 250, 40], ...
                               'Callback', @carregar_imagem);

    % Botões dos Filtros Sépia
    h.lbl_filtros = uicontrol(h.fig, 'Style', 'text', ...
                              'String', 'Variações Sépia:', 'FontSize', 10, ...
                              'Position', [50, 430, 250, 20]);

    h.btn_sepia1 = uicontrol(h.fig, 'Style', 'pushbutton', ...
                             'String', 'Sépia (1)', ...
                             'Position', [50, 390, 250, 30], ...
                             'Callback', {@aplicar_sepia, h, 1});

    h.btn_sepia2 = uicontrol(h.fig, 'Style', 'pushbutton', ...
                             'String', 'Sépia (2)', ...
                             'Position', [50, 350, 250, 30], ...
                             'Callback', {@aplicar_sepia, h, 2});

    h.btn_sepia3 = uicontrol(h.fig, 'Style', 'pushbutton', ...
                             'String', 'Sépia (3)', ...
                             'Position', [50, 310, 250, 30], ...
                             'Callback', {@aplicar_sepia, h, 3});

    % Botão de Salvamento
    h.btn_salvar = uicontrol(h.fig, 'Style', 'pushbutton', ...
                             'String', 'Salvar Imagem Processada', ...
                             'Position', [50, 200, 250, 40], ...
                             'Callback', @salvar_imagem, ...
                             'Enable', 'off'); % Desabilitado inicialmente

    % Guarda a estrutura de handles no proprio objeto da figura, permitindo acesso global
    set(h.fig, 'UserData', h);
endfunction


function carregar_imagem(obj, event)
    % 1. Recuperar a estrutura de 'handles' (h)
    h = get(gcbf, 'UserData'); % gcbf = Get Current Base Figure

    % 2. Abrir a Janela de Selecao de Arquivo
    [filename, pathname] = uigetfile({'*.jpg;*.png', 'Arquivos de Imagem (*.jpg, *.png)'}, 'Selecione a Imagem');

    if ischar(filename) % Verifica se o usuario selecionou um arquivo

        % 3. Construcao do Caminho Completo
        imagem_path = fullfile(pathname, filename);
        % keyboard;

        % 4. Normalizacao do Caminho
        % Esta etapa força a string a ser tratada de forma consistente
        if ispc()
            % Para Windows (se necessário), usa barras invertidas
            imagem_path = strrep(imagem_path, '/', '\');
        else
            % Para Linux/macOS, garante barras simples
            imagem_path = strrep(imagem_path, '\', '/');
        endif

        try
            % 5. Verificacao de Existencia e Leitura
            if exist(imagem_path, 'file') == 2
                img = imread(imagem_path);

                % Armazenar a imagem RGB original na estrutura 'h'
                h.img_rgb = img;
                h.img_processada = [];

                % 6. Exibicao da Imagem Original
                axes(h.axes);
                imshow(h.img_rgb);
                title(h.axes, ['Original: ', filename]);
                drawnow; % Força a atualização da tela

                % 7. Habilitar botoes de filtro e salvamento
                set(h.btn_sepia1, 'Enable', 'on');
                set(h.btn_sepia2, 'Enable', 'on');
                set(h.btn_sepia3, 'Enable', 'on');
                set(h.btn_salvar, 'Enable', 'off');

            else
                disp(['ERRO: Arquivo não encontrado no caminho: ', imagem_path]);
                return;
            endif

        catch ME
            disp(['ERRO NA LEITURA (imread) NO CONTEXTO DA GUI: ', ME.message]);
            return;
        end_try_catch

        % 8. Salvar as mudancas na estrutura 'h'
        set(h.fig, 'UserData', h);

    else
        disp('Carregamento de imagem cancelado.');
    endif
endfunction

function aplicar_sepia(obj, event, h, tipo_sepia)
    % Aplicando o filtro Sepia de acordo com 'tipo_sepia'
    h = get(gcbf, 'UserData');
    if isempty(h.img_rgb)
        disp('ERRO: Nenhuma imagem carregada. Carregue uma imagem primeiro.');
        return;
    endif

    % Converte para double e normaliza para [0, 1]
    img_double = double(h.img_rgb) / 255;
    R = img_double(:, :, 1);
    G = img_double(:, :, 2);
    B = img_double(:, :, 3);

    % Calculo da Luminosidade Ponderada; base para o Sépia
    L = 0.2989 * R + 0.5870 * G + 0.1140 * B;

    % Matrizes de Transformacao Sépia
    switch tipo_sepia
        case 1 % Sepia (1)
            sepia_R = L * 0.95;
            sepia_G = L * 0.90;
            sepia_B = L * 0.70;
        case 2 % Sepia (2)
            sepia_R = L * 1.0255;
            sepia_G = L * 0.8588;
            sepia_B = L * 0.6333;
        case 3 % Sepia (3)
            sepia_R = L * 1.20;
            sepia_G = L * 1.01;
            sepia_B = L * 0.89;
        otherwise
            disp('Tipo Sepia inválido.');
            return;
    endswitch

    % Limita valores no intervalo [0, 1]
    sepia_R = min(max(sepia_R, 0), 1);
    sepia_G = min(max(sepia_G, 0), 1);
    sepia_B = min(max(sepia_B, 0), 1);

    % Reconstroi e armazena a imagem processada (em uint8)
    img_sepia_double = cat(3, sepia_R, sepia_G, sepia_B);
    h.img_processada = uint8(img_sepia_double * 255);

    % Exibição e habilitacao do botao Salvar
    axes(h.axes);
    imshow(h.img_processada);
    title(h.axes, ['Sépia ', num2str(tipo_sepia), ' Aplicado']);
    drawnow;
    set(h.btn_salvar, 'Enable', 'on');
    set(h.fig, 'UserData', h);
endfunction

function salvar_imagem(obj, event)
    h = get(gcbf, 'UserData');
    if isempty(h.img_processada)
        disp('ERRO: Nenhuma imagem processada para salvar.');
        return;
    endif

    % Abre a Janela de Selecao de Arquivo.
    [filename, pathname] = uiputfile({'*.jpg;*.jpeg', 'JPEG (*.jpg, *.jpeg)'; ...
                                     '*.png', 'PNG (*.png)'}, ...
                                     'Salvar Imagem Processada', ...
                                     'sepia_imagem.jpg'); % Sugere JPEG por padrão

    if ischar(filename) % Se o usuario nao cancelou
        output_path = fullfile(pathname, filename);

        try
            % Verifica se o arquivo é JPEG para aplicar a Qualidade
            [~, ~, ext] = fileparts(output_path);

            if strcmpi(ext, '.jpg') || strcmpi(ext, '.jpeg')
                % Salva como JPEG com Qualidade 85
                imwrite(h.img_processada, output_path, 'Quality', 85);
            else
                % Salva outros formatos (como PNG) sem controle de qualidade
                imwrite(h.img_processada, output_path);
            endif

            % Implementação para verificar o tamanho
            if exist(output_path, 'file') == 2
                file_info = stat(output_path);
                tamanho_mb = file_info.size / (1024 * 1024);

                if tamanho_mb > 10
                    disp(['AVISO: Imagem salva (', num2str(tamanho_mb, 2), ' MB) excedeu o limite de 10 MB. Tente reduzir a Qualidade.']);
                else
                    disp(['Imagem salva com sucesso (', num2str(tamanho_mb, 2), ' MB) em: ', output_path]);
                endif
            endif

        catch ME
            disp(['ERRO AO SALVAR (imwrite): ', ME.message]);
        end_try_catch
    else
        disp('Salvamento cancelado.');
    endif
endfunction
