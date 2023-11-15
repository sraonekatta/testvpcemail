# ---- Base Node ----
ARG  AWS_REGION
FROM node:18.13.0-alpine AS base
RUN apk add --no-cache tini
WORKDIR /usr/src/app

# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]

# copy project file
COPY . .

# ---- Dependencies ----
FROM base AS dependencies
# install node packages
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production 
# copy production node_modules aside
RUN cp -R node_modules prod_node_modules
# install ALL node_modules, including 'devDependencies'
RUN npm install
 

# ---- Build ----
# run linters, setup and tests
FROM dependencies AS build
COPY . .
RUN  npm run build

#
# ---- Release ----
FROM base AS release
# copy production node_modules
COPY --from=dependencies /usr/src/app/prod_node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist

# expose port and define CMD
EXPOSE 4000
# CMD [ "node", "." ]
CMD ["npm", "run", "start:prod"]