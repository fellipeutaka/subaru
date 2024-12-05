import React from "react";

const template = `${JSON.stringify({ something: "else" })}`;

const Component = () => (
  <>
    <div>Something 1</div>
    <div>Something 2</div>
  </>
);

export const Main = () => (
  <div>
    <Component />
    {template}
    <Component />
  </div>
);

import type { Metadata, ResolvingMetadata } from "next";

type Props = {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
};

export async function generateMetadata(
  { params, searchParams }: Props,
  parent: ResolvingMetadata
): Promise<Metadata> {
  // read route params
  const id = (await params).id;

  // fetch data
  const product = await fetch(`https://.../${id}`).then((res) => res.json());

  // optionally access and extend (rather than replace) parent metadata
  const previousImages = (await parent).openGraph?.images || [];

  return {
    title: product.title,
    openGraph: {
      images: ["/some-specific-page-image.jpg", ...previousImages],
    },
  };
}

export default function Page({ params, searchParams }: Props) {}
